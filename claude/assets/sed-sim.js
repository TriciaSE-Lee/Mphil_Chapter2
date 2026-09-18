// Shared sed s/// playground. A small, honest simulator: it supports the
// same s/pattern/replacement/flags shape as real sed (any delimiter,
// \1..\9 backreferences, & for "whole match", g and i flags) but matches
// patterns using JS's regex engine rather than a real BRE/ERE engine.
// Good enough for teaching; not a substitute for a real terminal.
//
// Usage: <div class="playground" data-sed-playground>
//          <script type="application/json">
//            {"input": "line one\nline two", "placeholder": "s/foo/bar/",
//             "target": "optional exact expected output"}
//          </script>
//        </div>
// Then call initSedPlaygrounds() once after the DOM is parsed.

function parseSedCommand(cmd) {
  cmd = cmd.trim();
  if (cmd[0] !== "s") {
    throw new Error("Only the s/// command is supported here — start with 's'.");
  }
  var delim = cmd[1];
  if (!delim || delim === "\\") {
    throw new Error("Expected a delimiter right after 's', e.g. s/.../.../ ");
  }
  var parts = [];
  var current = "";
  var i = 2;
  while (i < cmd.length) {
    var ch = cmd[i];
    if (ch === "\\" && cmd[i + 1] === delim) {
      current += delim;
      i += 2;
      continue;
    }
    if (ch === delim) {
      parts.push(current);
      current = "";
      i += 1;
      continue;
    }
    current += ch;
    i += 1;
  }
  parts.push(current);

  if (parts.length < 3) {
    throw new Error("Command needs three " + delim + "-separated parts: pattern, replacement, flags.");
  }

  return { pattern: parts[0], replacement: parts[1], flags: parts[2] || "" };
}

function sedReplacementToJs(replacement) {
  var out = "";
  for (var i = 0; i < replacement.length; i++) {
    var ch = replacement[i];
    if (ch === "\\" && /[0-9]/.test(replacement[i + 1] || "")) {
      out += "$" + replacement[i + 1];
      i += 1;
    } else if (ch === "\\" && replacement[i + 1] === "&") {
      out += "&";
      i += 1;
    } else if (ch === "&") {
      out += "$&";
    } else if (ch === "$") {
      out += "$$";
    } else {
      out += ch;
    }
  }
  return out;
}

function runSedCommand(cmdText, inputText) {
  var parsed = parseSedCommand(cmdText);
  var jsFlags = parsed.flags.replace(/[^gi]/g, "");
  var regex;
  try {
    regex = new RegExp(parsed.pattern, jsFlags);
  } catch (e) {
    throw new Error("Bad pattern: " + e.message);
  }
  var jsReplacement = sedReplacementToJs(parsed.replacement);
  return inputText
    .split("\n")
    .map(function (line) {
      return line.replace(regex, jsReplacement);
    })
    .join("\n");
}

function initSedPlaygrounds(root) {
  root = root || document;
  var boxes = root.querySelectorAll("[data-sed-playground]");
  boxes.forEach(function (el) {
    if (el.dataset.sedInit) return;
    el.dataset.sedInit = "true";

    var spec = JSON.parse(el.querySelector("script[type='application/json']").textContent);

    var inputLabel = document.createElement("label");
    inputLabel.textContent = "Input";
    el.appendChild(inputLabel);

    var inputBox = document.createElement("textarea");
    inputBox.rows = Math.min(6, (spec.input.match(/\n/g) || []).length + 2);
    inputBox.value = spec.input;
    el.appendChild(inputBox);

    var cmdLabel = document.createElement("label");
    cmdLabel.textContent = "sed command";
    el.appendChild(cmdLabel);

    var cmdBox = document.createElement("input");
    cmdBox.type = "text";
    cmdBox.placeholder = spec.placeholder || "s/pattern/replacement/g";
    el.appendChild(cmdBox);

    var runBtn = document.createElement("button");
    runBtn.className = "run-btn";
    runBtn.type = "button";
    runBtn.textContent = "Run";
    el.appendChild(runBtn);

    var result = document.createElement("div");
    result.className = "result-box neutral";
    result.textContent = "(output appears here)";
    el.appendChild(result);

    runBtn.addEventListener("click", function () {
      var out;
      try {
        out = runSedCommand(cmdBox.value, inputBox.value);
      } catch (e) {
        result.className = "result-box bad";
        result.textContent = "Error: " + e.message;
        return;
      }
      result.textContent = out;
      if (spec.target !== undefined) {
        if (out === spec.target) {
          result.className = "result-box good";
        } else {
          result.className = "result-box bad";
        }
      } else {
        result.className = "result-box neutral";
      }
    });
  });
}

document.addEventListener("DOMContentLoaded", function () {
  initSedPlaygrounds(document);
});
