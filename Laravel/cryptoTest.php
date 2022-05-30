<?php

namespace App\Helpers;

use Illuminate\Encryption\Encrypter;


class cryptoTest

{
    private $key = '11111111111111111111111111111111'; //32 bit key

    public function encrypt_data($data){
        $data_encrypter =new Encrypter($this->key,'AES-256-CBC');
        $encrypted_data =$data_encrypter->encrypt($data);
        return $encrypted_data;
    }

    public function decrypt_data($data){
        $data_encrypter =new Encrypter($this->key,'AES-256-CBC');
        $decrypted_data =$data_encrypter->decrypt($data);
        return  $decrypted_data;
    }

}
