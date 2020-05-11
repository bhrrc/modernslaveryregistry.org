$(document).ready(function() {
  $(".keywords-select").select2({
    tags: true
  }).addClass("select2--keywords");

  $(".multiple-select").each(function() {
    $(this).select2({
      placeholder: $(this).data("placeholder")
    }).addClass("colored-select2").addClass($(this).data("color"));
  });

  $(document).on("click", ".change-search-criteria", function(e) {
    e.preventDefault();
    e.stopPropagation();

    $(".statements-search-form").attr("aria-hidden", "false");
  });

  var isRemovingFilterFromCriteria = false;

  $(document).on("click", ".pill", function(e) {
    e.preventDefault();
    e.stopPropagation();

    if (isRemovingFilterFromCriteria) {
      return;
    }

    isRemovingFilterFromCriteria = true;

    var value = $(this).data("value");

    if (value) {
      var fieldFor = $("select[name*='" + $(this).data("for") + "']");
      var selections = fieldFor.select2("data");
      var index = -1;

      selections.forEach(function(selection, i) {
        if (selection.text.toLowerCase() == value.toLowerCase()) {
          index = i;
        }
      });

      if (index > -1) {
        selections.splice(index, 1);

        var ids = selections.map(function(selection) {
          return selection.id;
        });

        fieldFor.val(ids);
        fieldFor.trigger("change");

        setTimeout(function() {
          $(".statements-search-form").submit();
        }, 1);
      }
    } else {
      var fieldFor = $("[name*='" + $(this).data("for") + "']");
      fieldFor.val("");

      setTimeout(function() {
        $(".statements-search-form").submit();
      }, 1);
    }
  });
})