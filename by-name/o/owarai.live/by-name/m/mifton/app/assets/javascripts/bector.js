//= require_tree .

$(window).on('scroll', function() {
  scrollHeight = $(document).height();
  scrollPosition = $(window).height() + $(window).scrollTop();
  if ( (scrollHeight - scrollPosition) / scrollHeight <= 0.05) {
    $('.jscroll').jscroll({
      contentSelector: '.post_list',
      nextSelector: 'a[rel=next]:last'
    });
  }
});

$(function(){
  $('.common_timeLine_data').on('click',
    function(e){
      e.stopPropagation();
      console.log("clicked");
    }
  );
});



// $(document).ready(function() {
//   console.log("ready");
//   $("#micropost_image").change(
//       function () {
//           console.log("readyimg");
//           if (!this.files.length) {
//               console.log("quitimg");
//               return;
//           }
//
//           var file = $(this).prop('files')[0];
//           var fr = new FileReader();
//
//           console.log(file);
//           console.log(fr);
//
//           $('.preview').css('background-image', 'none');
//           fr.onload = function() {
//               $('.preview').css('background-image', 'url(' + fr.result + ')');
//               $('.preview').css('width', '500px');
//               $('.preview').css('height', '300px');
//           }
//           fr.readAsDataURL(file);
//       }
//   );
// });
