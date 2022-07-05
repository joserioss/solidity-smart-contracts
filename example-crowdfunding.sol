// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

contract DemoAddress {
    uint public saldo;
    address private beneficiario;
    mapping(address=>uint) public aportes;
    uint public metaEsperada;
    bool private aportesAbiertos;
    bool private devolicionHabilitada;

    constructor(uint _meta){
        beneficiario = msg.sender;
        aportesAbiertos = true;
        metaEsperada = _meta;
        devolicionHabilitada = false;
    }

    function depositar() public payable {
        require(aportesAbiertos, "La colecta esta cerrada");
        saldo = saldo + msg.value;
        aportes[msg.sender] = aportes[msg.sender] + msg.value;
    }

    function retirarAporte() public {
        require(devolicionHabilitada, "Las devoluciones no estan habilitadas");
        require(aportes[msg.sender]>0, "No tienes saldo para retirar");
        payable(msg.sender).transfer(aportes[msg.sender]);
        saldo = saldo - aportes[msg.sender];
        aportes[msg.sender] = 0;
    }

    // Solo puede cerrar la colecta el beneficiario
    function cerrarAportes() public {
        require(msg.sender == beneficiario, "Solo puede llamar el beneficiario");
        require(aportesAbiertos, "La colecta esta cerrada");
        aportesAbiertos = false;
        if(saldo >= metaEsperada){
            payable(beneficiario).transfer(saldo);
            saldo = 0;
        } else{
            devolicionHabilitada = true;
        }
    }
}
