<?php

require 'vendor/autoload.php';

// load environment variables
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

$date = date('Y-m-d');

$result->getSize()

// create backup file
$container = $_ENV['DB_CONTAINER'];
$user = $_ENV['DB_USER'];
$password = $_ENV['DB_PASSWORD'];
exec("docker exec $container /usr/bin/mysqldump -u $user --password=$password --all-databases | gzip > backup.gz");

// create google client
$client = new Google\Client();
$client->setApplicationName('Drive MySQL Backup');
$client->setClientId($_ENV['DRIVE_CLIENT_ID']);
$client->setClientSecret($_ENV['DRIVE_CLIENT_SECRET']);
$client->refreshToken($_ENV['DRIVE_REFRESH_TOKEN']);

// create drive service
$service = new Google\Service\Drive($client);

// upload the file
$file = new Google\Service\Drive\DriveFile();
$file->setName("$date.gz");
$file->setParents([
    $_ENV['DRIVE_FOLDER_ID'],
]);
$result = $service->files->create($file, [
    'data' => file_get_contents('backup.gz'),
    'mimeType' => 'application/gzip',
    'uploadType' => 'multipart',
]);

exit($result->getSize());

// delete the backup file
unlink('backup.gz');

exit("Backup created for $date".');