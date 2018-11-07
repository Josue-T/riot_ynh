<?php

header('Content-Type: application/json');

$json_source = file_get_contents('config.json');
$json_data = json_decode($json_source);
$url = $json_data->default_hs_url;
$url = "$url/_matrix/client/r0/login?";

$remoteUser = $_SERVER['REMOTE_USER'];
$userPassword = $_SERVER['PHP_AUTH_PW'];
$deviceName = json_decode(file_get_contents('php://input'))->devicename;
$deviceName = preg_filter("/^([\w\s_.\/\-\:\.]*)$/", "$1", $deviceName);

if ($deviceName == '') {
    $deviceName = "Unknown device";
}

$data = array(
        "type" => "m.login.password",
        "password" => $userPassword,
        "identifier" => array(
            "type" => "m.id.user",
            "user" => $remoteUser
        ),
        "initial_device_display_name" => $deviceName,
        "user" => $remoteUser
    );
$data_string = json_encode($data);

// Get cURL resource
$curl = curl_init();

// Verbose mode for debug if needed
// $verbose = fopen('php://temp', 'w+');
// curl_setopt($curl, CURLOPT_VERBOSE, true);
// curl_setopt($curl, CURLOPT_STDERR, $verbose);
// curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);

//These next lines are for the magic "good cert confirmation"
curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, true);
curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 2);

//for local domains:
//you need to get the pem cert file for the root ca or intermediate CA that you signed all the domain certificates with so that PHP curl can use it...sorry batteries not included
//place the pem or crt ca certificate file in the same directory as the php file for this code to work
curl_setopt($curl, CURLOPT_CAINFO, '/var/www/riot/crt.pem');

curl_setopt_array($curl, array(
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_URL => $url,
    CURLOPT_POST => 1,
    CURLOPT_VERBOSE => 1,
    CURLOPT_HTTPHEADER => array('Content-Type:application/json', 'Content-Length: ' . strlen($data_string)),
    CURLOPT_POSTFIELDS => $data_string
));
// Send the request & save response to $resp
$resp = curl_exec($curl);

// verbose mode for debug if needed
// rewind($verbose);
// $verboseLog = stream_get_contents($verbose);
// echo "Verbose information:\n<pre>", htmlspecialchars($verboseLog), "</pre>\n";

curl_close($curl);

$json_resp = json_decode($resp);

$credentials = array(
    "homeserverUrl" => $json_data->default_hs_url,
    "identityServerUrl" => $json_data->default_is_url,
    "userId" => $json_resp->user_id,
    "deviceId" => $json_resp->device_id,
    "accessToken" => $json_resp->access_token,
    "guest" => false,
);

echo json_encode($credentials);
