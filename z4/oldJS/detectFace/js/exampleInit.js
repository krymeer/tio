 $(function(){
    $('#start-btn').on('click', function() {
        if ($('#img-url').length > 0)
        {
            var url = $('#img-url').val();
            var img = $('<img/>').attr('src', url);
            $('#img-box').html('').append(img);

            img.on('load', function() {
                if (img[0].naturalHeight > 0)
                {
                    detectFace(url);
                }
                else
                {
                    $('#logs').html('<span style="color: red">Error: file not found</span>');
                }
            });
        }
    });
});