// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


contract AuctionProject {
   //declara las variablrs de direcciones (address) publicas
    address public beneficiary;
    address public highestBidder;
    
    //declara las variables enteras(numeros) y publicas
    uint256 public auctionEndTime;
    uint256 public highestBid;
    uint256 public comision;
    // Declaro los array para emitir listado de ofertantes
    address[] listOfBidders;
    uint256[] listOfBids;

    mapping (address => uint256) public pendingReturns;
    //
    bool public auctionEnded;

    //declara los eventos que se desarrolaran en la subasta
    //"HigestBidIncreased" avisa que se ha incrementado el monto de la oferta desde una address
    //"AuctionEnded" avisa que ha ocurrido el final de la subasta 
    //"ExtendTimeEnd" avisa que se a extendido el tiempo de la subasta por 10min mas
    event HighestBidIncreased(address bidder, uint256 amount,string message);
    event AuctionEnded(address winner, uint256 amount, string message);
    event ExtendTimeEnd(uint256 auctionEndTime,string exTime);
    event StartMessage(string getstart);
    ///ingresar tiempo de subasta y cuenta de beneficiario
    //se implenta un constructor para dar los valores inicales a la subasta
    //
    constructor(uint256 _biddingTime, address _beneficiary){

        beneficiary= _beneficiary;
        auctionEndTime= block.timestamp + _biddingTime;
        emit StartMessage("La subasta empieza con la primera oferta");
    }

    function Bid() public payable{

        // verifico si si ha llegado el final por tiempo de la subasta
        require(!auctionEnded, "La subasta ya ha finalizado");
        require(msg.value > highestBid, "la oferta debe ser mayor a la actual");

        //La transaccion se realizara si la oferta entrante es 5% mayor a la actual
        require(msg.value >highestBid + highestBid *5 /100, "La oferta debe ser al menos 5% mayor a la actual");

        // La oferta se toma si aun faltan mas de 10min para el tiempo 
        require(auctionEndTime - block.timestamp > 600 ,"No hay tiempo para realizar la oferta");

        // El sgte bloque verifica que la direccion es distinta de la "0"
        //luego guarda el monto en el recipente que corresponde na esa direccion
        if(highestBidder != address(0)){ 

           //guarda la oferta en su correspondiente casillero y la actualiza  
           pendingReturns[highestBidder] += highestBid;
         
         
        }        
           highestBidder = msg.sender;
           highestBid = msg.value;

           //cargo los arrays para el listado final
           listOfBidders.push(highestBidder);
           listOfBids.push(highestBid);

           //Avisos para los participantes 
           
           emit HighestBidIncreased(msg.sender, msg.value,"Se incremento la oferta");

          //planteo alargar la subasta por 10minutos mas
           auctionEndTime= auctionEndTime +600;     
           emit ExtendTimeEnd(auctionEndTime, "Se agregan 10 minutos mas a la subasta");  
        
        
    }   
    
    function withDraw() public payable {

        require(msg.sender != highestBidder, "El ganador no puede retirar");
        // verifico si el remitente tiene fondos, si tiene guarda el valor
        require (pendingReturns[msg.sender] > 0, "No tienes fondos para retirar");
        // saco el m0nto del casillero y lo asigno a amount
        uint256 amount = pendingReturns[msg.sender];
        //Reseteo el monto en el casillero
        pendingReturns[msg.sender] = 0;
        //Al monto no ganador le calculo el descuento del 2% de comision de la subasta
        uint256 porcent = amount * 2/100;
            
        //descuento de la comision del 2%
        amount -= porcent;
        // Acumulo los porcentajes
        comision += porcent;
            
        //devuelve el monto no ganador y verifica que se haya realizado con exito
        (bool success, ) = msg.sender.call{value: amount} (" ");
        require(success, "Fallo de la devolucion del monto");        

    }

       function auctionEnd() public {
        require(block.timestamp >= auctionEndTime, "La subasta aun no ha terminado");
        require(!auctionEnded, "La subasta ya finalizo");
        auctionEnded = true;
        //Emite la direccion y el monto del ganador
        emit AuctionEnded(highestBidder, highestBid, "Es el ganador de la subasta!");

        // Envio el activo de la subasta al ganador"
        // Aquí

        //Envio de los fondos al beneficiario
        (bool success, ) = beneficiary.call{value:highestBid}(" ");
        require(success, "Fallo el envio de fondos al beneficiario");
    }

    function getListOfBids() public view returns(uint256[] memory, address[] memory){

        return (listOfBids ,listOfBidders) ;
        
    }

}
