# Solidity_Codes
Proyectos en Solidity
Se trata de un Smart Contract que crea una Subasta.
Para iniciar el deploy hay que agregar el tiempo de duracion de la subasta y a una cuenta que representa la beneficiaria.
Una ves iniciada la subasta se debe ingresar la nueva cuenta con la nueva oferta,que debe ser superadora en al menos 5% de la anterior.
Sepueden ingresar ofertas hasta 10 minutos antes del tiempo de caducacion de la subasta.
Por cada oferta superadora validada se agregaran 10 minutos mas al tiempo total de la subasta.

Variables  que se pueden setear y/o consultar:
-beneficiary:Contiene la cuenta (address) del beneficiario de la subasta
-comision :Contiene los porcentajes (2%) acumulados que se descontaron de cada uno de los paraticipantes de la subasta.
-highestBid:Contine el monto actual del que va ganando la puja.Una ves terminada la subasta se concierte en el monto ganador.
-highestBidder:Contiene la direccion del que va ganando la puja.Una ves terminada la subasta se convirte en el direccion del ganador.
-pendigReturn:Contiene el monto o balance actual de la cuenta (address) que se consulta.
-auctionEnded
-auctionEndTime:Contiene el tiempo en que se inicia la subasta y luego se va actualizando en 10 minutos ,cada ves que se valida una oderta de una cuenta.

Arrays donde se guardan cuentas y valores para generar un listado:
-address []listOfBidders
-int256[]listOfbids

Mappings donde se guardan los cuentas y valores ofrecidos validados
-mapping[]pendingReturn:

Funciones usadas
Constructor() :Funcion inicial que necesita que se ingrese el tiempo de duracion de la subasta (_biddingTime) y la cuenta del beneficiario (_benefitiary)
function Bid():Funcion que admite como parametros la nueva cuenta (msg.sender) y su oferta (msg.value) , que pasaran por procesos de validacion para ser aceptada
function withDraw():Funcion que permite el retiro de los fondos de una cuenta que fue validada en su momento y perdio la puja,con el descuento automatico del 2% de comision
function auctionEnd():Realiza varias validaciones,que la subasta "no haya finalizado","si la subasta ya terminó" y si hubo error al envio de los fondos al  beneficiario.
                      Ademas emite un evento con la direccion y el oferta del ganador de la subasta.
function getListOfBids():Realiza un listado de las ofertas con sus correspondientaes cuentas que participaron de la subasta.



