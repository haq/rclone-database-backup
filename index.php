<?php

require 'vendor/autoload.php';

// load environment variables
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

// constant environment variables
$container = $_ENV['DB_CONTAINER'];
$user = $_ENV['DB_USER'];
$password = $_ENV['DB_PASSWORD'];

// get all the database names
exec("docker exec -it $container /usr/bin/mysql -u $user --password=$password -Bse 'show databases;'", $databases);

// remove (information_schema & mysql & performance_schema & sys)
$databases = array_filter($databases, function (string $value) {
    return $value !== 'information_schema'
        && $value !== 'mysql'
        && $value !== 'performance_schema'
        && $value !== 'sys';
});

// name of the files that have been exported
$exportedFiles = [];

// loop through each database name
foreach ($databases as $database) {

    $file = "$database.sql";

    // export the database
    exec("docker exec $container /usr/bin/mysqldump -u $user --password=$password $database > $file");

    // add the exported file name to the array
    array_push($exportedFiles, $file);
}

// create a gzipped tarball
exec('tar -czf backup.tar.gz ' . implode(' ', $exportedFiles));

// create google client
$client = new Google\Client();
$client->setClientId($_ENV['DRIVE_CLIENT_ID']);
$client->setClientSecret($_ENV['DRIVE_CLIENT_SECRET']);
$client->refreshToken($_ENV['DRIVE_REFRESH_TOKEN']);

// create drive service
$service = new Google\Service\Drive($client);

// create the file object
$file = new Google\Service\Drive\DriveFile();
$file->setName(date('Y-m-d') . '.tar.gz');
$file->setParents([
    $_ENV['DRIVE_FOLDER_ID'],
]);

// upload the file
$result = $service->files->create($file, [
    'data' => file_get_contents('backup.tar.gz'),
    'mimeType' => 'application/gzip',
    'uploadType' => 'multipart',
]);

// delete each of the database files
foreach ($exportedFiles as $file) {
    unlink($file);
}

// delete the gzipped tarball file
unlink('backup.tar.gz');

exit('Backup created.');