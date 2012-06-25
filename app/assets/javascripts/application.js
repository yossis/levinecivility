// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function() {



  //refresh chat messages
  if ($('#messages').length) {
	  setInterval(function(){
      $.getScript(window.location + '&auto=true', function(data, textStatus, jqxhr) {
        console.log(data); //data returned
        console.log(textStatus); //success
        console.log(jqxhr.status); //200
        console.log('Load was performed.');
      });
	  },2000);
  }

  // function to get query parameter
  function getParameterByName(name) {
 
    var match = RegExp('[?&]' + name + '=([^&]*)')
                    .exec(window.location.search);
 
    return match ?
        decodeURIComponent(match[1].replace(/\+/g, ' '))
        : null;
 
  }

  //redirect to qualtrics after a fixed period of chatting
  if(window.location.pathname == '/pairings/chat'){
    var participant_code = getParameterByName('participant_code');
    var participant_id = getParameterByName('participant_id');
    var id = getParameterByName('id');
    var which_chat = getParameterByName('which_chat');
    setInterval(function(){ 
      alert('Your chat time has finished and now you will be redirected back to your survey.');
        if(which_chat == 1){
          //window.location = 'http://wharton.qualtrics.com/SE/?SID=SV_8GEE97brucNde6w&stage=2&participant_code=' + participant_code;
          window.location = '/pairings/end_chat?participant_code=' + participant_code + '&which_chat=' + which_chat + '&id=' + id;
        }
        if(which_chat == 2){
          //window.location = 'http://wharton.qualtrics.com/SE/?SID=SV_8GEE97brucNde6w&stage=3&participant_code=' + participant_code;
          window.location = '/pairings/end_chat?participant_code=' + participant_code + '&which_chat=' + which_chat + '&id=' + id;
        }
    },20000);
  }

  //refresh the waiting for partner page
  if ($('#wait').length) {
    setTimeout(function(){
      location.reload(true);
    },5000);
  }

});

















