"use strict";

$(document).ready(function() {
  // Replace the morelink spans with anchors so that they're clickable
  $(".morelink").each(function() {
    let repl = "<a href='#' id='" + $(this).attr("id") + "' class='" + $(this).attr("class") + "'>";
    repl = repl + $(this).html() + "</a>";
    $(this).replaceWith(repl);
  });

  // Now decorate the morelink anchors with the "?" and make them clickable
  $(".morelink").each(function() {
    $("<span class='moreicon'>?</span>").insertAfter(this);
    let id = $(this).attr("id");
    if (id && id.endsWith("-link")) {
      let anchor = $("#" + id.substring(0, id.length - 5) + "-anchor");
      if ($(anchor).attr("id")) {
        $(this).click(function(e) {
          e.preventDefault();
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
