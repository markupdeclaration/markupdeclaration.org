"use strict";

$(document).ready(function() {
  $(".morelink").each(function() {
    $("<span class='moreicon'>?</span>").insertAfter(this);
    let id = $(this).attr("id");
    if (id && id.endsWith("-link")) {
      let anchor = $("#" + id.substring(0, id.length - 5) + "-anchor");
      if ($(anchor).attr("id")) {
        $(this).click(function() {
          if ($(anchor).css("display") == "block") {
            $(anchor).css("display", "none");
          } else {
            $(anchor).fadeIn("slow");
          }
        });
      }
    }
  });

  $(".moreinfo").each(function() {
    $(this).css("display", "none");
  });
});
