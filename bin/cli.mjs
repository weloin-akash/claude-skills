#!/usr/bin/env node
/**
 * weloin-skills — install Claude Code skills from this package into ~/.claude/skills,
 * and its slash commands into ~/.claude/commands/<namespace>/ (commands/weloin/save.md
 * becomes /weloin:save). Skills are opt-in per skill; a command namespace is
 * all-or-nothing, so every install/sync links it and `uninstall --all` removes it.
 *
 *   weloin-skills                       interactive checkbox picker
 *   weloin-skills --all                 install every skill
 *   weloin-skills --skills=a,b,c        install named skills (with or without "weloin:" prefix)
 *   weloin-skills list                  table of skills: installed state + one-line explainer
 *   weloin-skills uninstall [--all|--skills=...]
 *   weloin-skills sync                  re-link everything in the manifest (runs on npm postinstall)
 *
 *   flags: --copy (copy instead of symlink)  --force (replace foreign dirs, backed up)  --silent
 */
import fs from 'node:fs';
import path from 'node:path';
import os from 'node:os';
import { fileURLToPath } from 'node:url';
import * as p from '@clack/prompts';

const PKG_ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const SKILLS_SRC = path.join(PKG_ROOT, 'skills');
const TARGET_DIR = process.env.WELOIN_SKILLS_TARGET || path.join(os.homedir(), '.claude', 'skills');
const MANIFEST = process.env.WELOIN_SKILLS_MANIFEST || path.join(os.homedir(), '.claude', 'weloin-skills.json');
const IS_WIN = process.platform === 'win32';
// Slash commands ride along in the same package but land in ~/.claude/commands/<namespace>/,
// where the directory name IS the namespace: commands/weloin/save.md -> /weloin:save.
// They are not selectable like skills — a namespace is all-or-nothing, so every
// install/sync links them and `uninstall --all` removes them.
const COMMANDS_SRC = path.join(PKG_ROOT, 'commands');
const COMMANDS_TARGET = process.env.WELOIN_COMMANDS_TARGET || path.join(os.homedir(), '.claude', 'commands');

// ---------- helpers ----------

function parseFrontmatter(file) {
  const text = fs.readFileSync(file, 'utf8');
  const m = text.match(/^---\r?\n([\s\S]*?)\r?\n---/);
  if (!m) return {};
  const out = {};
  for (const line of m[1].split(/\r?\n/)) {
    const kv = line.match(/^(\w[\w-]*):\s*(.*)$/);
    if (kv) out[kv[1]] = kv[2].trim();
  }
  return out;
}

function oneLine(desc = '') {
  // first sentence, before any "Triggers" clause, hard cap 100 chars
  let s = desc.split(/\bTriggers?\b/)[0];
  const dot = s.indexOf('. ');
  if (dot > 20) s = s.slice(0, dot + 1);
  s = s.trim().replace(/[,;-]$/, '');
  return s.length > 100 ? s.slice(0, 97) + '...' : s;
}

function installName(fmName, dir) {
  const name = fmName || `weloin:${dir}`;
  return IS_WIN ? name.replaceAll(':', '-') : name; // ":" illegal in Windows paths
}

function readSkills() {
  if (!fs.existsSync(SKILLS_SRC)) return [];
  return fs.readdirSync(SKILLS_SRC, { withFileTypes: true })
    .filter((d) => d.isDirectory() && fs.existsSync(path.join(SKILLS_SRC, d.name, 'SKILL.md')))
    .map((d) => {
      const src = path.join(SKILLS_SRC, d.name);
      const fm = parseFrontmatter(path.join(src, 'SKILL.md'));
      const name = installName(fm.name, d.name);
      return { dir: d.name, name, desc: oneLine(fm.description), src, ...targetState(name, src) };
    })
    .sort((a, b) => a.name.localeCompare(b.name));
}

// state of ~/.claude/skills/<name>: none | linked (ours) | copy (per manifest) | foreign
function targetState(name, src) {
  const target = path.join(TARGET_DIR, name);
  let st;
  try { st = fs.lstatSync(target); } catch { return { target, state: 'none' }; }
  if (st.isSymbolicLink()) {
    try {
      const real = fs.realpathSync(target);
      if (real === fs.realpathSync(src)) return { target, state: 'linked' };
    } catch { /* dangling */ }
    return { target, state: 'foreign' };
  }
  const manifest = loadManifest();
  if (manifest.installed?.[name]?.mode === 'copy') return { target, state: 'copy' };
  return { target, state: 'foreign' };
}

function loadManifest() {
  try { return JSON.parse(fs.readFileSync(MANIFEST, 'utf8')); } catch { return { installed: {} }; }
}
function saveManifest(m) {
  fs.mkdirSync(path.dirname(MANIFEST), { recursive: true });
  fs.writeFileSync(MANIFEST, JSON.stringify(m, null, 2) + '\n');
}

function removeTarget(target) {
  fs.rmSync(target, { recursive: true, force: true });
}

function backup(target) {
  const bak = `${target}.bak-${new Date().toISOString().slice(0, 19).replaceAll(':', '')}`;
  fs.renameSync(target, bak);
  return bak;
}

// Link every namespace under commands/ into ~/.claude/commands/. Same safety rules as
// skills: our own link is replaced, a foreign directory is left alone unless --force
// (and is backed up first). Copies where symlinks are not permitted.
function linkCommands({ copy = false, force = false, log = console.log } = {}) {
  if (!fs.existsSync(COMMANDS_SRC)) return 0;
  const namespaces = fs.readdirSync(COMMANDS_SRC, { withFileTypes: true }).filter((d) => d.isDirectory());
  if (!namespaces.length) return 0;
  fs.mkdirSync(COMMANDS_TARGET, { recursive: true });
  let n = 0;
  for (const d of namespaces) {
    const src = path.join(COMMANDS_SRC, d.name);
    const target = path.join(COMMANDS_TARGET, d.name);
    let state = 'none';
    try {
      const st = fs.lstatSync(target);
      state = 'foreign';
      if (st.isSymbolicLink()) {
        try { if (fs.realpathSync(target) === fs.realpathSync(src)) state = 'linked'; } catch { /* dangling */ }
      } else if (loadManifest().commands?.[d.name]?.mode === 'copy') {
        state = 'copy';
      }
    } catch { /* none */ }

    if (state === 'foreign') {
      if (!force) { log(`  skip  /${d.name}:* — existing non-managed dir at ${target} (use --force to replace, backs up first)`); continue; }
      log(`  moved existing to ${backup(target)}`);
    } else if (state !== 'none') {
      removeTarget(target);
    }

    let asCopy = copy;
    if (asCopy) {
      fs.cpSync(src, target, { recursive: true });
    } else {
      try {
        fs.symlinkSync(src, target, IS_WIN ? 'junction' : 'dir');
      } catch (e) {
        log(`  symlink failed (${e.code}); falling back to copy`);
        fs.cpSync(src, target, { recursive: true });
        asCopy = true;
      }
    }
    const m = loadManifest();
    m.commands ||= {};
    m.commands[d.name] = { mode: asCopy ? 'copy' : 'symlink' };
    saveManifest(m);
    const names = fs.readdirSync(src).filter((f) => f.endsWith('.md')).map((f) => `/${d.name}:${f.slice(0, -3)}`);
    log(`  ${asCopy ? 'copied' : 'linked'}  ${names.join('  ')} -> ${target}`);
    n++;
  }
  return n;
}

function unlinkCommands({ log = console.log } = {}) {
  const m = loadManifest();
  for (const ns of Object.keys(m.commands || {})) {
    removeTarget(path.join(COMMANDS_TARGET, ns));
    log(`  removed /${ns}:*`);
  }
  delete m.commands;
  saveManifest(m);
}

function doInstall(skill, { copy = false, force = false, log = console.log }) {
  fs.mkdirSync(TARGET_DIR, { recursive: true });
  const { target, state } = targetState(skill.name, skill.src);
  if (state === 'foreign') {
    if (!force) { log(`  skip  ${skill.name} — existing non-managed dir at ${target} (use --force to replace, backs up first)`); return false; }
    const bak = backup(target);
    log(`  moved existing to ${bak}`);
  } else if (state !== 'none') {
    removeTarget(target); // ours — safe to replace (refresh link/copy)
  }
  if (copy) {
    fs.cpSync(skill.src, target, { recursive: true });
  } else {
    try {
      fs.symlinkSync(skill.src, target, IS_WIN ? 'junction' : 'dir');
    } catch (e) {
      log(`  symlink failed (${e.code}); falling back to copy`);
      fs.cpSync(skill.src, target, { recursive: true });
      copy = true;
    }
  }
  const m = loadManifest();
  m.installed ||= {};
  m.installed[skill.name] = { dir: skill.dir, mode: copy ? 'copy' : 'symlink' };
  saveManifest(m);
  log(`  ${copy ? 'copied' : 'linked'}  ${skill.name} -> ${target}`);
  return true;
}

function doUninstall(skill, { log = console.log }) {
  const { target, state } = targetState(skill.name, skill.src);
  if (state === 'foreign') { log(`  skip  ${skill.name} — not managed by weloin-skills`); return false; }
  if (state === 'none') { log(`  --    ${skill.name} — not installed`); return false; }
  removeTarget(target);
  const m = loadManifest();
  delete m.installed?.[skill.name];
  saveManifest(m);
  log(`  removed ${skill.name}`);
  return true;
}

// ---------- argument parsing ----------

const argv = process.argv.slice(2);
const flags = new Set(argv.filter((a) => /^--[a-z]+$/.test(a)));
const cmd = argv.find((a) => !a.startsWith('--')) || 'install';
const skillsArg = argv.find((a) => a.startsWith('--skills='))?.slice(9);
const silent = flags.has('--silent');
const log = silent ? () => {} : console.log;
const opts = { copy: flags.has('--copy'), force: flags.has('--force'), log };

function pickByNames(all, csv) {
  const wanted = csv.split(',').map((s) => s.trim()).filter(Boolean);
  const found = [];
  const missing = [];
  for (const w of wanted) {
    const s = all.find((k) => k.name === w || k.dir === w || k.name === `weloin:${w}` || k.name === installName(null, w));
    s ? found.push(s) : missing.push(w);
  }
  if (missing.length) {
    console.error(`Unknown skill(s): ${missing.join(', ')}\nAvailable: ${all.map((s) => s.dir).join(', ')}`);
    process.exit(1);
  }
  return found;
}

// ---------- commands ----------

const STATE_ICON = { linked: '✔ linked', copy: '✔ copied', foreign: '⚠ foreign', none: '·' };

const all = readSkills();
if (all.length === 0) { console.error(`No skills found in ${SKILLS_SRC}`); process.exit(1); }

if (cmd === 'list') {
  const w = Math.max(...all.map((s) => s.name.length));
  for (const s of all) log(`${s.name.padEnd(w)}  ${STATE_ICON[s.state].padEnd(9)}  ${s.desc}`);
  process.exit(0);
}

if (cmd === 'sync') {
  const m = loadManifest();
  const entries = Object.entries(m.installed || {});
  // Commands are not opt-in per skill, so sync always refreshes them — including the
  // first `npm install`, where the skills manifest is still empty.
  linkCommands(opts);
  if (!entries.length) { log('sync: no skills in manifest'); process.exit(0); }
  log(`Re-syncing ${entries.length} skill(s) from manifest:`);
  for (const [name, info] of entries) {
    const s = all.find((k) => k.name === name || k.dir === info.dir);
    if (!s) { log(`  gone  ${name} — no longer in package, leaving as-is`); continue; }
    doInstall(s, { ...opts, copy: info.mode === 'copy' });
  }
  process.exit(0);
}

if (cmd === 'uninstall') {
  const targets = flags.has('--all') ? all.filter((s) => s.state === 'linked' || s.state === 'copy')
    : skillsArg ? pickByNames(all, skillsArg)
    : null;
  if (!targets) { console.error('uninstall needs --all or --skills=a,b,c'); process.exit(1); }
  targets.forEach((s) => doUninstall(s, opts));
  if (flags.has('--all')) unlinkCommands(opts); // a namespace is all-or-nothing
  process.exit(0);
}

if (cmd !== 'install') { console.error(`Unknown command: ${cmd}`); process.exit(1); }

// install
let targets;
if (flags.has('--all')) {
  targets = all;
} else if (skillsArg) {
  targets = pickByNames(all, skillsArg);
} else {
  // interactive checkbox picker
  if (!process.stdout.isTTY) { console.error('No TTY — use --all or --skills=a,b,c'); process.exit(1); }
  p.intro('weloin-skills installer');
  const picked = await p.multiselect({
    message: 'Select skills to install/update (space = toggle, a = all, enter = confirm)',
    options: all.map((s) => ({
      value: s.dir,
      label: `${s.name}  ${s.state !== 'none' ? `[${STATE_ICON[s.state]}]` : ''}`,
      hint: s.desc,
    })),
    initialValues: all.filter((s) => s.state === 'linked' || s.state === 'copy').map((s) => s.dir),
    required: false,
  });
  if (p.isCancel(picked) || !picked.length) { p.outro('Nothing selected.'); process.exit(0); }
  targets = picked.map((dir) => all.find((s) => s.dir === dir));
  p.outro(`Installing ${targets.length} skill(s)…`);
}

log(`Target: ${TARGET_DIR}  (mode: ${opts.copy ? 'copy' : 'symlink'})`);
let ok = 0;
for (const s of targets) if (doInstall(s, opts)) ok++;
if (linkCommands(opts)) log(`Commands: ${COMMANDS_TARGET}`);
log(`Done — ${ok}/${targets.length} installed.`);
