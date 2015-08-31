
var fs = require('fs');
var layer = require('cloud/layer-parse-module/layer-module.js');

var layerProviderID = 'layer:///providers/1da5ff8c-5006-11e5-8bd3-d4eb521b5510'; 
var layerKeyID = 'layer:///keys/5b54fb86-5014-11e5-b0e3-d4eb521b5510';
var privateKey = fs.readFileSync('cloud/layer-parse-module/keys/layer-key.js');
layer.initialize(layerProviderID, layerKeyID, privateKey);

Parse.Cloud.define("generateToken", function(request, response) {
    var currentUser = request.user;
    if (!currentUser) throw new Error('You need to be logged in!');
    var userID = currentUser.id;
    var nonce = request.params.nonce;
    if (!nonce) throw new Error('Missing nonce parameter');
        response.success(layer.layerIdentityToken(userID, nonce));
});