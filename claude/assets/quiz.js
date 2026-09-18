// Shared retrieval-practice quiz widget.
// Usage: <div class="quiz" data-quiz>
//          <script type="application/json">
//            {"prompt": "...", "choices": ["...", "...", "...", "..."],
//             "correct": 0, "explain": "..."}
//          </script>
//        </div>
// Then call initQuizzes() once after the DOM is parsed.

function initQuizzes(root) {
  root = root || document;
  var quizzes = root.querySelectorAll("[data-quiz]");
  quizzes.forEach(function (el) {
    if (el.dataset.quizInit) return;
    el.dataset.quizInit = "true";

    var spec = JSON.parse(el.querySelector("script[type='application/json']").textContent);

    var prompt = document.createElement("div");
    prompt.className = "quiz-prompt";
    prompt.textContent = spec.prompt;
    el.appendChild(prompt);

    var options = document.createElement("div");
    options.className = "quiz-options";
    el.appendChild(options);

    var feedback = document.createElement("div");
    feedback.className = "quiz-feedback";
    el.appendChild(feedback);

    var answered = false;

    spec.choices.forEach(function (choiceText, i) {
      var btn = document.createElement("button");
      btn.className = "quiz-choice";
      btn.type = "button";
      btn.textContent = choiceText;
      btn.addEventListener("click", function () {
        if (answered) return;
        answered = true;
        var buttons = options.querySelectorAll("button");
        buttons.forEach(function (b, j) {
          if (j === spec.correct) b.classList.add("correct");
        });
        if (i === spec.correct) {
          btn.classList.add("correct");
          feedback.textContent = "Correct. " + (spec.explain || "");
        } else {
          btn.classList.add("incorrect");
          feedback.textContent = "Not quite. " + (spec.explain || "");
        }
        feedback.classList.add("shown");
      });
      options.appendChild(btn);
    });
  });
}

document.addEventListener("DOMContentLoaded", function () {
  initQuizzes(document);
});
