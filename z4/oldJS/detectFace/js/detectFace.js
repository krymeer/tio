var features = ["5oclock shadow", "bald", "beard", "goatee", "heavy makeup", "mustache", "sideburns", "wearing earrings", "wearing lipstick", "wearing necklace", "wearing necktie"];

function detectFace(url) {
    var requestData = {
        api_key:            'd45fd466-51e2-4701-8da8-04351c872236',
        file_uri:           url,
        detection_flags:    'classifiers'
    }

    $.ajax({
        url: 'https://www.betafaceapi.com/api/v2/media',
        headers: {
            'Content-Type': 'application/json',
            'accept':       'application/json'
        },
        method: 'POST',
        data: JSON.stringify(requestData)
    }).done(function(responseData) {
        console.log(responseData);
        processFaceTags(responseData, url);
    });
}

function processFaceTags(data, url) {
    var tags            = data.media.faces[0].tags;
    var filteredTags    = $.grep(tags, function(tag) { return features.includes(tag.name) });
    var faceArray       = [];
    var faceArrayDescr  = [];

    for (var k = 0; k < filteredTags.length; k++)
    {
        var binaryValue = (filteredTags[k].value === 'yes')? 1 : 0;
        faceArrayDescr.push(filteredTags[k].name);
        faceArray.push(binaryValue)
    }

    if ($('#logs').length > 0)
    {
        $('#logs').text($('#logs').text() + url + '\n' + faceArray + '\n\n');
    }
}