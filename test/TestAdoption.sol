// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0; // Disesuaikan dengan versi compiler di gambar Anda (0.5.16)

// Mengimpor library standar Truffle untuk assertion (pengecekan)
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Adoption.sol"; // Mengimpor smart contract yang akan kita test

contract TestAdoption {
  // Mengambil instance dari smart contract Adoption yang sudah dideploy
  Adoption adoption = Adoption(DeployedAddresses.Adoption());

  // ID hewan peliharaan yang akan kita gunakan untuk testing
  uint expectedPetId = 8;

  // Alamat yang diharapkan menjadi pemilik (yaitu alamat smart contract test ini)
  address expectedAdopter = address(this);

  // TEST 1: Menguji fungsi adopt()
  // Memastikan fungsi mengembalikan ID hewan yang benar setelah diadopsi
  function testUserCanAdoptPet() public {
    uint returnedId = adoption.adopt(expectedPetId);
    
    Assert.equal(returnedId, expectedPetId, "Adoption of the expected pet should match what is returned.");
  }

  // TEST 2: Menguji pengambilan data pemilik tunggal
  // Memastikan public getter 'adopters' menyimpan alamat pengadopsi dengan benar
  function testGetAdopterAddressByPetId() public {
    address adopter = adoption.adopters(expectedPetId);
    
    Assert.equal(adopter, expectedAdopter, "Owner of the expected pet should be this contract");
  }

  // TEST 3: Menguji pengambilan seluruh array pemilik
  // Memastikan fungsi getAdopters() mengembalikan array yang berisi alamat kita di index yang benar
  function testGetAdopterAddressByPetIdInArray() public {
    // Menyimpan adopters di memory (bukan storage)
    address[16] memory adopters = adoption.getAdopters();
    
    Assert.equal(adopters[expectedPetId], expectedAdopter, "Owner of the expected pet should be this contract");
  }
}