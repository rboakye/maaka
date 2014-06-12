/**
 * Created with JetBrains RubyMine.
 * User: rboakye
 * Date: 1/10/14
 * Time: 9:06 PM
 * To change this template use File | Settings | File Templates.
 */

$(document).ready(function () {

});

 $(document).on('click', '.set_recorder', function() {
     // variables
     var leftchannel = [];
     var rightchannel = [];
     var recorder = null;
     var recording = false;
     var recordingLength = 0;
     var volume = null;
     var audioInput = null;
     var sampleRate = 44100;
     var audioContext = null;
     var context = null;

     if (!navigator.getUserMedia)
         navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia ||
             navigator.mozGetUserMedia || navigator.msGetUserMedia;

     if (navigator.getUserMedia){
         navigator.getUserMedia(
         {
           audio: true
         },
         success, function(e) {
             alert('Error capturing audio.');
         });
     } else alert('Browser does not support audio, use firefox or chrome.');

     function record(word){
         recording = true;
        // reset the buffers for the new recording
         leftchannel.length = rightchannel.length = 0;
         recordingLength = 0;

         // after 2 seconds it stop recording and process audio
         var timer = setInterval(function(){
             recording = false;
             // we flat the left and right channels down
             var leftBuffer = mergeBuffers ( leftchannel, recordingLength );
             var rightBuffer = mergeBuffers ( rightchannel, recordingLength );

             // we interleave both channels together
             var interleaved = interleave ( leftBuffer, rightBuffer );

             // create the buffer and view to create the .WAV file
             var buffer = new ArrayBuffer(44 + interleaved.length * 2);
             var view = new DataView(buffer);

             // write the WAV container, check spec at: https://ccrma.stanford.edu/courses/422/projects/WaveFormat/
             // RIFF chunk descriptor
             writeUTFBytes(view, 0, 'RIFF');
             view.setUint32(4, 44 + interleaved.length * 2, true);
             writeUTFBytes(view, 8, 'WAVE');
             // FMT sub-chunk
             writeUTFBytes(view, 12, 'fmt ');
             view.setUint32(16, 16, true);
             view.setUint16(20, 1, true);
             // stereo (2 channels)
             view.setUint16(22, 2, true);
             view.setUint32(24, 44100, true);
             view.setUint32(28, 44100 * 4, true);
             view.setUint16(32, 4, true);
             view.setUint16(34, 16, true);
             // data sub-chunk
             writeUTFBytes(view, 36, 'data');
             view.setUint32(40, interleaved.length * 2, true);

             // write the PCM samples
             var lng = interleaved.length;
             var index = 44;
             var volume = 1;
             for (var i = 0; i < lng; i++){
                 view.setInt16(index, interleaved[i] * (0x7FFF * volume), true);
                 index += 2;
             }

             // our final binary blob that we can hand off
             var blob = new Blob ( [ view ], { type : 'audio/wav' } );

             //set next element spinner
             var current_word = $('.audio-sentence span').find('.show');
             current_word.toggleClass("hide show");

             var next_word = $('.audio-sentence').find('.next');

             if(next_word.length){
                 next_word.find('i').toggleClass("hide show");
             }

             // let's save it locally
             var url = (window.URL || window.webkitURL).createObjectURL(blob);
             var link = window.document.createElement('a');
             link.href = url;
             link.download = word + '.wav';
             var text = document.createTextNode("Download");
             link.appendChild(text)
             link.title = 'Download';
             $('.download-wav').html(link.outerHTML);

             var click = new Event('click');
             link.addEventListener('click', function (e){
             }, false);
             link.dispatchEvent(click);

             clearInterval(timer);
         },2000);
     }

     function mergeBuffers(channelBuffer, recordingLength){
         var result = new Float32Array(recordingLength);
         var offset = 0;
         var lng = channelBuffer.length;
         for (var i = 0; i < lng; i++){
             var buffer = channelBuffer[i];
             result.set(buffer, offset);
             offset += buffer.length;
         }
         return result;
     }

     function interleave(leftChannel, rightChannel){
         var length = leftChannel.length + rightChannel.length;
         var result = new Float32Array(length);

         var inputIndex = 0;

         for (var index = 0; index < length; ){
             result[index++] = leftChannel[inputIndex];
             result[index++] = rightChannel[inputIndex];
             inputIndex++;
         }
         return result;
     }

     function writeUTFBytes(view, offset, string){
         var lng = string.length;
         for (var i = 0; i < lng; i++){
             view.setUint8(offset + i, string.charCodeAt(i));
         }
     }

     function success(e){
         // creates the audio context
         audioContext = window.AudioContext || window.webkitAudioContext;
         context = new audioContext();

         // creates a gain node
         volume = context.createGain();

         // creates an audio node from the microphone incoming stream
         audioInput = context.createMediaStreamSource(e);

         // connect the stream to the gain node
         audioInput.connect(volume);

         /* From the spec: This value controls how frequently the audioprocess event is
          dispatched and how many sample-frames need to be processed each call.
          Lower values for buffer size will result in a lower (better) latency.
          Higher values will be necessary to avoid audio breakup and glitches */
         var bufferSize = 2048;
         recorder = context.createScriptProcessor(bufferSize, 2, 2);

         recorder.onaudioprocess = function(e){
             if(!recording) return;
             var left = e.inputBuffer.getChannelData (0);
             var right = e.inputBuffer.getChannelData (1);
             // we clone the samples
             leftchannel.push (new Float32Array (left));
             rightchannel.push (new Float32Array (right));
             recordingLength += bufferSize;
         }

         // we connect the recorder
         volume.connect (recorder);
         recorder.connect (context.destination);

         //initiate the recorder button
         $('.record').addClass('start');
         $('.set_recorder').addClass('disabled');
         if($('.audio-sentence').children().length > 1){
             $('.record').removeClass('disabled');
             var current_word = $('.audio-sentence').find('.next');
             current_word.find('i').toggleClass("hide show");
         }
     }

     $('.record').click(function(){
         var current_word = $('.audio-sentence').find('.next');
         var next_word = current_word.next('span');
         if(next_word.length){
             current_word.removeClass("next");
             next_word.addClass('next');
         }else{
             current_word.removeClass("next");
             $('.record').addClass('disabled');
         }

         record(current_word.text().trim());

     });
 });

    $(document).on('click', '.download-wav', function() {
       $('.download-wav').html("");
    });





/*
     Good: events are bound outside a $() wrapper.
     $(document).on('click', 'button', function() { ... })
 */