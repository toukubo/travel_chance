<?php
define("WORK_SPACE", "php_workspace");
define("URL", FULL_BASE_URL . '/' . WORK_SPACE . '/' . basename(ROOT) . '/');
define("API", URL . "api" . '/');
define("API_GMO", "http://ad.smaad.jp/api/iteminfo/getListDetail");
define("ZONE_ID", "");
define('PRODUCTION_HOSTNAME', '');
define('STAGING_HOSTNAME', 'http://153.128.30.213/');
define('LOCAL_HOSTNAME', 'localhost');
define('ADD_USER', 'addUser');
define('DO_LOGIN', 'doLogin');
define('GET_LIST_DETAIL', 'getListDetail');
define('UPLOAD', 'upload');
define('PICTURES', IMAGES.'pictures' . DS);
define('PICTURES_PATH', FULL_BASE_URL . '/' . basename(ROOT) . '/' . IMAGES_URL . 'pictures/');
