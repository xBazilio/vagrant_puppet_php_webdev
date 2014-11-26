#!/usr/bin/php
<?php
/*
 * Script catches stream intended for sendmail and saves it in .eml files.
 *
 * Settings:
 * 1. Script should be executable
 *
 * 2. Put path to this script in php.ini. For example:
 *    sendmail_path = "/var/www/mailtool.php"
 *
 * 3. In variable $mailDir below set path to folder where the .eml files will be saved
 */


$mailDir = "/home/vagrant/www/EMAILS/";
$fileName = date('Y-m-d_H.i.s') . "[". round(microtime(true), 3) ."]";

// получаем поток
$contents = file_get_contents("php://stdin");

// Нужно все одиночные \n Заменить на \r\n
$pattern = "/(\\n(\\r)?)|(\\r(\\n)?)/m";
$replacement = "\r\n";
$contents = preg_replace($pattern, $replacement, $contents);

// запишем в файл
file_put_contents($mailDir . "{$fileName}.eml", $contents);
exit();
