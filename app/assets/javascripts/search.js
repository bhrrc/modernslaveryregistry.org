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
})