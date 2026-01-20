//= require_tree .

  $(function(){
  $('.components_bectorFunctionBar_buttons_micropostButton').on('click',
    function(){
      $(this).blur();
      $(".components_modalOverlay").fadeIn("slow");
      $(".components_micropostModal").fadeIn("slow").css('display','flex');
    }
  );

  $('.components_mobileDropButton').on('click',
    function(){
      $(this).blur();
      $(".components_modalOverlay").fadeIn("slow");
      $(".components_micropostModal").fadeIn("slow");
      $(".components_mobileDropButton").fadeOut("slow");
    }
  );

  $('.components_bectorFunctionBar_buttons_topicButton').on('click',
    function(){
      $(this).blur();
      $(".components_modalOverlay").fadeIn("slow");
      $(".components_topicModal").fadeIn("slow").css('display','flex');
    }
  );

  $('.components_micropostModal_closeButton').on('click',
    function(){
      $(this).blur();
      $(".components_modalOverlay").fadeOut("slow");
      $(".components_micropostModal").fadeOut("slow");
      var windowWidth = window.innerWidth;
      if (windowWidth < 1024) {
        $(".components_mobileDropButton").fadeIn("slow");
      }
    }
  );

  $('.components_topicModal_closeButton').on('click',
    function(){
      $(this).blur();
      $(".components_modalOverlay").fadeOut("slow");
      $(".components_topicModal").fadeOut("slow");
      var windowWidth = window.innerWidth;
      if (windowWidth < 1024) {
        $(".components_mobileDropButton").fadeIn("slow");
      }
    }
  );

  $('.components_modalOverlay').on('click',
    function(){
      $(this).blur();
      $(".components_modalOverlay").fadeOut("slow");
      $(".components_micropostModal").fadeOut("slow");
      $(".components_topicModal").fadeOut("slow");
      var windowWidth = window.innerWidth;
      if (windowWidth < 1024) {
        $(".components_mobileDropButton").fadeIn("slow");
      }
    }
  );
});
