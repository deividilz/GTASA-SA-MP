//INCLUDES
#include <a_samp>
#include <dof2>
#include <core>
#include <float>
#include <streamer>
#include <dini>
#include <sscanf2>

#include <fly>
//IGNORAR MÁ-IDENTAÇÃO
#pragma tabsize 0
//RADIUS DA TRAVA DO /CONTADOR
#define FREEZEZONE 50
#define MAX_GANGS 20

#define VERMELHO                0xFF030FFF
#define VERMELHO_CLARO          0xFB0000FF
#define AMARELO                 0xFFFF00FF
#define AZUL_CLARO              0x00C2ECFF
#define ROXO                    0xB360FDFF
#define VERDE_CLARO             0x38FF06FF
#define CINZA                   0xCECECEFF

new Text:ImagemEntrada;
new Text:topblack, Text:bottomblack;

new Text: texto1;
new Text: texto9;
new Text: texto8;

new Text:Textdraw25;
new Text:Textdraw26;
new Text:Textdraw27;
new Text:Textdraw28;
new Text:Textdraw29;
new Text:Textdraw30;

#define UsarGpsText 4 //GPS AGPS
new Text:TextGPS1[MAX_PLAYERS],Text:TextGPS2[MAX_PLAYERS];
new bool:Piscando[MAX_PLAYERS],Cores[MAX_PLAYERS];
new bool:AGps[MAX_PLAYERS];

#define bandana 1000
#define EventoProntoDialog 2424
//TEMPO PRA MUDAR O TEMPO
#define MudarTempoMS 7200254

//TEMPO PRA MUDAR O WORLDTIME
#define AtualizarWorldTime 60000

//TEMPOS DO COMBATE A/D
#define AAD_TIME_TempoDeEsperaLobby 60000 //1 MINUTO
#define AAD_TIME_DuracaoDaPartida 300000 //5 MINUTOS
#define AAD_TIME_IntervaloEntrePartidas 3600000 //1 Hora

//TEMPOS DO COMBATE GTAV
#define PVC_TIME_TempoDeEsperaLobby 60000 //1 MINUTO
#define PVC_TIME_DuracaoDaPartida 120000 //5 MINUTOS
#define PVC_TIME_IntervaloEntrePartidas 1000000

//TEMPOS DO COMBATE POLICIA LADRAO
#define PL_TIME_TempoDeEsperaLobby 60000//60000 //1 MINUTO
#define PL_TIME_DuracaoDaPartida 300000 //5 MINUTOS
#define PL_TIME_IntervaloEntrePartidas 2400000//40 min

//TEMPOS PARA EVENTOS ALEATORIOS NO MAPA
#define EAM_TIME_TempoDeEsperaLobby 10000//100000
#define EAM_TIME_DuracaoDaPartida 300000 //5 MINUTOS
#define EAM_TIME_IntervaloEntrePartidas 900000 //15 minutos

//TIME ASSISTIR PLAYER NA MORTE
#define TempoAssistirMorto 15

#define SLOTCAPACETE 4
#define COLOR_ZIELONY 0xFF00FF

//CORES

#define HEX_VERDE 		{00FF00}
#define HEX_LARANJA 	{E66C09}
#define HEX_VERMELHO	{FF00FF}
#define HEX_BRANCO      {FFFFFF}
#define HEX_CINZA       {C1C1C1}

//XENON
#define BlueColor 0x375FFFFF
#define RedColor 0xFF0000AA
#define XenonDialog 1


//dialogs do lider
#define DIALOG_CRIAR            4518
#define DIALOG_INFO             4519
#define DIALOG_NOMEG            4520
#define DIALOG_SKIN             4521
#define DIALOG_CONVIDAR         4522
#define DIALOG_PROMOVER         4524
#define DIALOG_PROMOVER2        4525
#define DIALOG_DEMITIR          4526
#define DIALOG_SPAWN            4528
#define DIALOG_ENCERRAR         4531
#define DIALOG_CONVIDADO        4523
#define DIALOG_COR              4529

#define COLOUR_INFORMACAOGANG 0x00A4D6FF




#define COLOUR_INFORMACAO 0x21CC21FF
#define COLOUR_AVISO 0xEAFC19FF
#define COLOUR_ERRO 0xFF0000FF
#define COLOUR_TELEPORTE 0xCC3361FF
#define COLOUR_DICA 0x77ADB5FF
#define COLOUR_EVENTO 0xFF5A00FF
#define COLOUR_EVENTOCANCELADO 0xC1C1C1FF
#define COLOUR_CHATPROX 0x00FFFFFF
#define COLOUR_BRANCO 0xFFFFFFFF
#define COLOUR_CINZA 0xC1C1C1FF
#define COLOUR_PINK 0xFF00FFFF
#define Cor_DoubleKill 0xF3FF82FF
#define Cor_MultiKill 0xFFE882FF
#define Cor_UltraKill 0xFFC982FF
#define Cor_Fantastic 0xFF9D82FF
#define Cor_Unbelievable 0xFF6363FF
#define Cor_VeryUnbelievable 0xFF4D00FF

#define Branco 0xFFFFFFAA
#define Cinza 0xC0C0C0AA
#define Amarelo 0xFFFF00FF
#define Dourado 0xDDB66BFF
#define Vermelho 0xFF0000AA
#define VermelhoEscuro 0xfAA3333AA
#define VerdeClaro 0x8BF63EFF
#define AzulClaro 0x33CCFFAA
#define AzulEscuro 0x057ABDAA
#define Roxo 0xB96BF6FF
#define Laranja 0xFF8000FF
#define VotacaoDialog 487

new bool:Enquete, bool:EnqueteVotou[MAX_PLAYERS], TotalEnqueteVotos,EnqueteVotosSim,EnqueteVotosNao, EnqueteMensagem[256],EnqueteMensagemDialog[256];
//DCMD
#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1

//FORWARDS DE FUNÇÕES PÚBLICAS
forward WeatherTimer();
forward RandomWeather();
forward RandomMSGs();

new StringTable[][] =
{
"[ERRO]: Você está em uma arena. Para sair: /sair",
"[ERRO]: O teleporte não aceita este veículo",
"[ERRO]: Você está em um local em que os teleportes são bloqueados",
"[ERRO]: Você não pode se teleportar dentro do evento. Para sair: /SAIR",
"[ERRO]: Este teleporte está temporariamente desabilitado",
"[INFO]: Se os objetos estiverem invisíveis, saia de seu veículo e entre novamente",
"[ERRO]: Você não pode usar este comando com pouca vida",
"[ERRO]: Você deve sair do interior",
"[ERRO]: Você não tem permissão para isso",
"[ERRO]: Você já está em uma arena. Para sair: /sair",
"[ERRO]: Jogador não conectado"
};

new VehicleNames[212][] = {
	"Landstalker","Bravura","Buffalo","Linerunner","Pereniel","Sentinel","Dumper","Firetruck","Trashmaster","Stretch","Manana","Infernus",
	"Voodoo","Pony","Mule","Cheetah","Ambulance","Leviathan","Moonbeam","Esperanto","Taxi","Washington","Bobcat","Mr Whoopee","BF Injection",
	"Hunter","Premier","Enforcer","Securicar","Banshee","Predator","Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach","Cabbie",
	"Stallion","Rumpo","RC Bandit","Romero","Packer","Monster","Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder",
	"Reefer","Tropic","Flatbed","Yankee","Caddy","Solair","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider",
	"Glendale","Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler","ZR3 50","Walton","Regina",
	"Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer","Maverick","News Chopper","Rancher","FBI Rancher","Virgo","Greenwood",
	"Jetmax","Hotring","Sandking","Blista Compact","Police Maverick","Boxville","Benson","Mesa","RC Goblin","Hotring Racer A","Hotring Racer B",
	"Bloodring Banger","Rancher","Super GT","Elegant","Journey","Bike","Mountain Bike","Beagle","Cropdust","Stunt","Tanker","RoadTrain",
	"Nebula","Majestic","Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV1000","Cement Truck","Tow Truck","Fortune","Cadrona","FBI Truck",
	"Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex","Vincent","Bullet","Clover",
	"Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob","Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monster A",
	"Monster B","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger","Flash","Tahoma","Savanna","Bandito","Freight","Trailer",
	"Kart","Mower","Duneride","Sweeper","Broadway","Tornado","AT-400","DFT-30","Huntley","Stafford","BF-400","Newsvan","Tug","Trailer A","Emperor",
	"Wayfarer","Euros","Hotdog","Club","Trailer B","Trailer C","Andromada","Dodo","RC Cam","Launch","Police Car (LSPD)","Police Car (SFPD)",
	"Police Car (LVPD)","Police Ranger","Picador","S.W.A.T. Van","Alpha","Phoenix","Glendale","Sadler","Luggage Trailer A","Luggage Trailer B",
	"Stair Trailer","Boxville","Farm Plow","Utility Trailer"
};

//DECLARAÇÃO DAS VARIÁVEIS GLOBAIS

// Enums
enum Dados
{
	Lider,
	Membro,
	Cargo,
	bool:LocalSpawn
}

new PlayerDados[MAX_PLAYERS][Dados];

enum GangsInfo
{
	ID,
	Nomeg,
	CorG,
	Skin,
	SpawnX,
	SpawnY,
	SpawnZ,
}

new StringGang[256];
new Gang[MAX_GANGS];
new gangs;
new IdConvidou;
new IdGangC;
new IdPromovido;
//new CargoNome[128];
new bool: ExcluiGang = false;

enum info
{
	matou,
	morreu,
	losses,
	wins,
	score
};

enum GPSInfo
{
zone_name[30],
Float:zone_minx,
Float:zone_miny,
Float:zone_minz,
Float:zone_maxx,
Float:zone_maxy,
Float:zone_maxz
};

/*new AssistirTimer[MAX_PLAYERS];
new bool:Assistindo[MAX_PLAYERS];*/
new GangInfo[MAX_GANGS][GangsInfo];
new GPS_Update_Timer[MAX_PLAYERS];
new COLOR_Update_Timer[MAX_PLAYERS];
new bool:GPS_Ativo[MAX_PLAYERS];
new bool:DuelArena[MAX_PLAYERS] = false;
new Player[MAX_PLAYERS][info];
new Duel[MAX_PLAYERS];
new bool:EventoSkyFall = false;
new bool:EventoCorridaCC = false;
new bool:EventoCorridaLV = false;
new ESCMLS;
new ESCMDLS[2];
new ESCCF;
new MTAREA51[5];
new SKYFALL;
new CorridaLV;
new CorridaCC;
new bool:X1sArena[MAX_PLAYERS];
new Float:VerVida;
new Float:VerColete;
new NickEsconder[MAX_PLAYERS];
new CorCacada[MAX_PLAYERS];
new ArenacOns = 0;
new arenacacadaEsconder[MAX_PLAYERS];
new noTotForest[MAX_PLAYERS];
new bool:mortohs[MAX_PLAYERS];
new ccolete[MAX_PLAYERS];
new vida[MAX_PLAYERS];
new AutoDeletarPickTimer;
new LastVehicleModel[MAX_PLAYERS];
new LastVChanges[MAX_PLAYERS];
new VChanges[MAX_PLAYERS];
new TimerNotBlinker;
new bool:NotificarBlinking;
new bool:NotBlinker;
new TimerSNP2;
new BotTolerance;
new bool:PontoAT[MAX_PLAYERS];
new bool:PontoU[MAX_PLAYERS];
new Float:PontoX[MAX_PLAYERS];
new Float:PontoY[MAX_PLAYERS];
new Float:PontoZ[MAX_PLAYERS];
new Float:PontoF[MAX_PLAYERS];
new PontoI[MAX_PLAYERS];
new PontoW[MAX_PLAYERS];
new ShowLogLines[MAX_PLAYERS];
new BanLipTick;
new LastConnectionTick;
new LastIPConnected[16];
new LastIPBannedLIP[16];
new bool:MostrandoFPSPing[MAX_PLAYERS];
new EventoNome[22];
new bool:SNP2Liberado = false;
new bool:SNP2[MAX_PLAYERS];
new DamageTick[MAX_PLAYERS];
new bool:OuvindoRadio[MAX_PLAYERS];
new SvFullValue = MAX_PLAYERS;
new SvFullValueMinutes = 5;
new bool:Mecanica[MAX_PLAYERS];
new bool:Altimetro[MAX_PLAYERS];
new L_PreDefStateChanges[MAX_PLAYERS];
new PreDefStateChanges[MAX_PLAYERS];
new bool:SpeedHack[MAX_PLAYERS];
new LastDeathTick[MAX_PLAYERS];
new Anova;
new ChamadoParaX1Por[MAX_PLAYERS];
new CX1Tipo[MAX_PLAYERS];
new bool:Bugar[MAX_PLAYERS];
new bool:AFK[MAX_PLAYERS];
new ABanNick[22];
new bool:Tela3Displaying = false;
new TimerTELA3;
new MensagemADMAtivado;
new ADMTick[MAX_PLAYERS];
new X1CTick[MAX_PLAYERS];
new GranaFacilValor;
new AwaySeconds[MAX_PLAYERS];
new Float:LastPosHash[MAX_PLAYERS];
new Float:LastDarGranaPos[MAX_PLAYERS];
new bool:StuntSuperSpeed[MAX_PLAYERS];
new Neon[2][MAX_PLAYERS],Neons;
//XENON
new Xenons[MAX_PLAYERS][20];
new Xenon[MAX_PLAYERS];
new XenonContagem;
new XenonVerifica[MAX_PLAYERS];
new ScoreNaSessao[MAX_PLAYERS];
new AF_UltimoComando[MAX_PLAYERS];
new Float:ccX, Float:ccY, Float:ccZ, Float:ccX2, Float:ccY2, Float:ccZ2, CountStage = 0, timer, Float:dist;
new pName[MAX_PLAYER_NAME], Frozen[MAX_PLAYERS];
new Freeze = 1, Locality = 1;
new UltimoVeiculoGM;
new Reparar[MAX_PLAYERS];
new Spree[MAX_PLAYERS];
new cmdtick[MAX_PLAYERS];
new Arena[MAX_PLAYERS];
new Arena2[MAX_PLAYERS];
new X1CLOSED = 0;
new X1WCLOSED = 0;
new X1;
new X1W;
new ArenaTipo[MAX_PLAYERS];
new GodCarOn[MAX_PLAYERS];
new TickCounter;
new HeliKills[MAX_PLAYERS];
new veiculo[MAX_PLAYERS];
new vtrancado[MAX_VEHICLES];
new AutoTrancar[MAX_PLAYERS];
new Text:Textdraw1;
new Text:Textdraw3;
new Text:TDEditor_TD[7];
new Text:Textdraw7;
new Text:Textdraw8;
new Text:Textdraw10;
new Text:Status[MAX_PLAYERS];
new HappyHour = 0;
new AntiWeapon = 1;
new Rojoes[MAX_PLAYERS];
new preso[MAX_PLAYERS];
new TimerSoltar[MAX_PLAYERS];
new cadeiastring[64];
new TimerMV[MAX_PLAYERS];
new ArenaKills[MAX_PLAYERS];
new ArenaKills2[MAX_PLAYERS];
new EventoAtivo;
new EventoPausado;
new NoEvento[MAX_PLAYERS];
new EventoMatarAoSairVeiculo = 0;
new EventoMatarAoSairDerby[MAX_PLAYERS];
new EventoDarColete = 0;
new EventoDarLife = 0;
new EventoDarSpeed = 0;
new EventoDarVeiculoID = 0;
new DerbyDarVeiculoID = 0;
new Derby[MAX_PLAYERS];
new EventoDarArmaID = 0;
new EventoVeiculos = 1;
new EventoCarregar = 0;
new EventoDesarmar = 0;
new EventoGranadas = 0;
new EventoProibirCS = 1;
new EventoProibirGC = 0;
new EventoProibirFlip = 0;
new EventoAdminID = -1;
new bool:EventoSPA = false;
new bool:EventoACEF = false;
new bool:EventoRojao = false;
new bool:EventoProibirTele = false;
new bool:EventoKitWalk = false;
new bool:EventoKitRun = false;
new bool:EventoSemDanos = false;
new bool:EventoOHK = false;
new bool:EventoRecarregarLife = false;
new EventoVeiculo[MAX_PLAYERS];
new Float:evento_x;
new Float:evento_y;
new Float:evento_z;
new Float:evento_f;
new evento_vw;
new evento_in;
new pickupammu;
new Text:TxDTela3;
new Text:TxDNotificador;
new TeleLockTimer[MAX_PLAYERS];
new LoaderFreezer = 1;
new Notificando[128];
new DefaultHostname[80] = "[BRASIL] MUNDO DOS PIKAS [MdP]";
new VPlayerMissao[MAX_PLAYERS];
new PlayerMissaoTipo[MAX_PLAYERS];
new VPlayerMissaoLucro[MAX_PLAYERS];
new VMissaoString[MAX_PLAYERS][30];
new Float:VMissaoPosX[MAX_PLAYERS];
new Float:VMissaoPosY[MAX_PLAYERS];
new Float:VMissaoPosZ[MAX_PLAYERS];
new VMissaoTick[MAX_PLAYERS];
new VMissaoDistancia[MAX_PLAYERS];
new VMissaoDestinoTXT[MAX_PLAYERS][100];
new DistanciaMis[MAX_PLAYERS];
new DistanciaMis2[MAX_PLAYERS];
new transferencias[MAX_PLAYERS];
new cor[MAX_PLAYERS];
new skin[MAX_PLAYERS];
new DarPau = 0;
new UltraGCAtivoParaTodos = 1;
new UltraGC[MAX_PLAYERS];
new Float:UltraGC_VIDA[MAX_PLAYERS];
new Float:UltraGC_COLETE[MAX_PLAYERS];
new timerclock;
new Float:PlayerCustomSpawn_X[MAX_PLAYERS];
new Float:PlayerCustomSpawn_Y[MAX_PLAYERS];
new Float:PlayerCustomSpawn_Z[MAX_PLAYERS];
new Float:PlayerCustomSpawn_F[MAX_PLAYERS];
new PlayerCustomSpawn_I[MAX_PLAYERS];
new PlayerCustomSpawn[MAX_PLAYERS];
new NV[36];
new SURFAEROLS;
new SSSArena[20];
new AAD_Vai[MAX_PLAYERS];
new AAD_Team[MAX_PLAYERS];
new AAD_Lobby;
new AAD_EmProgresso;
new AAD_KillsPerPlayer[MAX_PLAYERS];
new AAD_Kills_1;
new AAD_Kills_2;
new AAD_Balancer;
new AAD_Tipo;
new AAD_Tipo_STR[20];
new AAD_Participantes;
new AAD_TopKillerID_Kills;
new AAD_TopKillerID;
new AAD_TopKillerID_NAME[MAX_PLAYER_NAME];
new AAD_Vencedor;
new AAD_Vencedor_STR[40];
new AAD_OldPlayerColor[MAX_PLAYERS];
new AAD_DominandoTimer[MAX_PLAYERS];
new AAD_DominandoINT[MAX_PLAYERS];
new AAD_Dominado;
new AAD_Timer;

new bool:EventoProibirTeleEAM[MAX_PLAYERS] = false;
new bool:EAM_Checkpoint[MAX_PLAYERS] = false;
new bool:EAM_Player[MAX_PLAYERS] = false;
new bool:EAM_PlayerMorto = false;
new EAM_Lobby =0;
new EAM_EmProgresso;
new EAM_Tipo;
new EAM_Tipo_STR[50];
new EAM_Timer;
new bool:EAM_QuantPlayer = false;
new bool:EAM_Escolher = false;
new bool:EAM_ESC[MAX_PLAYERS] = false;

new PL_Veiculos[30];
new PL_TempSpawn;
new PL_Vai[MAX_PLAYERS];
new PL_Team[MAX_PLAYERS];
new PL_Lobby;
new PL_EmProgresso;
new PL_KillsPerPlayer[MAX_PLAYERS];
new PL_Kills_1;
new PL_Kills_2;
new PL_Balancer;
new PL_Participantes;
new PL_TopKillerID_Kills;
new PL_TopKillerID;
new PL_TopKillerID_NAME[MAX_PLAYER_NAME];
new PL_Vencedor_STR[40];
new PL_Vencedor;
new PL_OldPlayerColor[MAX_PLAYERS];
new PL_Timer;
new PL_Skin1;
new PL_Skin2;
//new PL_DominandoTimer[MAX_PLAYERS];
//new PL_DominandoINT[MAX_PLAYERS];
//new PL_Dominado;
new PL_Final;
new bool:PL_DominadoEntregar = false;
new PL_PlayerCD[MAX_PLAYERS];

new PVC_Round;
new PVC_VeiculosObjetosCarro[15];
new PVC_VeiculosObjetosMoto[15];
new PVC_Objetos[51];
new bool:PVC_Escolher = false;
new bool:PVC_Carro = false;
new bool:PVC_Moto = false;
new PVC_Morte_1;
new PVC_Morte_2;
new PVC_Morte_A;
new PVC_Morte_B;
new PVC_Vai[MAX_PLAYERS];
new PVC_Team[MAX_PLAYERS];
new PVC_TeamBkp[MAX_PLAYERS];
new PVC_Lobby;
new PVC_EmProgresso;
new PVC_KillsPerPlayer[MAX_PLAYERS];
new PVC_Kills_1;
new PVC_Kills_2;
new PVC_Balancer;
new PVC_Tipo;
new PVC_Tipo_STR[20];
new PVC_Nome_Time[20];
new PVC_NomeTime[MAX_PLAYERS];
new bool: PVC_TeamA[MAX_PLAYERS] = false;
new bool: PVC_TeamB[MAX_PLAYERS] = false;
new PVC_Participantes;
new PVC_Vencedor;
new PVC_Vencedor_STR[40];
new PVC_OldPlayerColor[MAX_PLAYERS];
new PVC_Timer;
new PVC1, PVC2, PVC3, PVC4, PVC5, PVC6;

new AutoPaintOn[MAX_PLAYERS];
new MostrandoVelocimetro[MAX_PLAYERS];
new MostrandoStatus[MAX_PLAYERS];
new UltimoVeiculoUsado[MAX_PLAYERS];
new Text3D:TextoVeiculo[MAX_PLAYERS];
new Text3D:TextoHead[MAX_PLAYERS];
new Text3D:Primeiro3DTXT;
new Text3D:GranaFacil3DTXT;
new GlobalHour,GlobalHour2;
new XuxaPC[MAX_PLAYERS];
new Weather[MAX_PLAYERS];
new AutoCiclo = 1;
new pDrunkLevelLast[MAX_PLAYERS];
new pFPS[MAX_PLAYERS];
new KillSpree[MAX_PLAYERS],TimerKillSpree[MAX_PLAYERS];
new PickGeral,PickGeral2,PickGeral3,PickGeral4, PickBHD;
new NewKillerID[MAX_PLAYERS],LastKillerID[MAX_PLAYERS],SendoAbusado[MAX_PLAYERS];
new bool:PiscarLuzesState[MAX_PLAYERS];
new bool:PiscarLuzes[MAX_PLAYERS];
new HydraGM;
new SeaspGM;
new bool:Capacete[MAX_PLAYERS];
new bool:NascerComColete[MAX_PLAYERS];
new bool:NascerColeteGratis[MAX_PLAYERS];
new bool:NascerComKw[MAX_PLAYERS];
new bool:NascerComKr[MAX_PLAYERS];
new bool:NascerComTp[MAX_PLAYERS];
new bool:NascerComKitGuerra[MAX_PLAYERS];
new bool:UsandoTXTPlaca[MAX_PLAYERS];
new bool:Gay[MAX_PLAYERS];
new SorteiosFeitos[MAX_PLAYERS];
new Text3D:TXTPlaca[MAX_PLAYERS];
new MSGTimer;
new bool:AntiRojao[MAX_PLAYERS];
new Txverifica[MAX_PLAYERS];

new MSGs[][] = {
"[DICA]: Colabore para manter o servidor sem bugs, caso encontre, notifique-nos!",
"[DICA]: Senhas esquecidas e contas com senhas vazadas nunca serão recuperadas",
"[DICA]: Os administradores reais nunca pedirão sua senha ou dados pessoais",
"[DICA]: Tome muito cuidado com os fakes de admins no Whatsapp/Facebook.",
"[DICA]: Os administradores nunca pedem sua senha. Se pedirem, nunca passe!",
"[DICA]: Sua senha é a proteção da sua conta, nunca passe para NINGUEM!",
"[DICA]: Se desconfiar que alguém saiba da sua senha, use o: /MUDARSENHA",
"[DICA]: Nunca passe sua senha para ninguém! Caso contrário perderá seu status.",
"[DICA]: Nunca passe sua senha para ninguém, nem mesmo para admins",
"[DICA]: Contato dos DONOS em: /contatos",
"[DICA]: Nunca confie em administradores fora do servidor ou do: /ADMINS",
"[DICA]: Para alternar a exibição de SCORE/FPS digite: /FPS",
"[DICA]: Para ouvir uma rádio online diretamente no jogo: /RADIOS",
"[DICA]: Para saber a altitude em relação ao nível do mar: /ALT",
"[DICA]: Para saber o status (life) de seu veículo: /MC",
"[DICA]: Os lucros das propriedades são pagos a cada 2 minutos",
"[DICA]: Se estiver inativo há mais de 2 minutos, não receberá lucros",
"[DICA]: Se estiver inativo com o servidor lotado poderá ser kickado",
"[DICA]: Você pode saber quem está com Hydra, Seasparrow, etc: /RADAR",
"[DICA]: Seasparrow do servidor: No lago marrom, próximo a /RALLY",
"[DICA]: Você pode criar placas no jogo por $10000: /PLACA",
"[DICA]: Novo X1 com arenas simultâneas e possibilidade de convite: /X1C",
"[DICA]: Arena de X1 ilimitada: /X1C",
"[DICA]: Para saber o lucro do Grana Fácil sem ir para LV: /GRANAFACIL",
"[DICA]: Saiba quantos players estão online em seu grupo: /GRUPOONS",
"[DICA]: Chat por canal, grupo ou inter-clans: /GRUPO",
"[DICA]: Você pode criar um grupo para chat particular: /GRUPO",
"[DICA]: Ao lado do Ammunation próximo a /LV há uma área que lhe dá grana!",
"[DICA]: Você pode enviar uma mensagem para os administradores: /ADM",
"[DICA]: Saiba quanto tempo um player está inativo usando: /INATIVO",
"[DICA]: Sem dinheiro? Vá ao lado do Ammunation LV e ganhe grana por segundo!",
"[DICA]: Para visulizar o neon do seu carro de dia, mude seu tempo: /MT",
"[DICA]: Para visulizar o xenon do seu carro de dia, mude seu tempo: /MT",
"[DICA]: O sistema de neons é limitado a 10 veículos para evitar crash's",
"[DICA]: O sistema de xenons é limitado a 10 veículos para evitar crash's",
"[DICA]: Você pode colocar neon em seu veículo: /NEON",
"[DICA]: Você pode colocar neon em seu veículo: /XENON",
"[DICA]: Procurando alguém? Tente: /ID <nick>",
"[DICA]: Ranking dos players online: /RANK",
"[DICA]: Está entre os melhores? Confira em: /RANK",
"[DICA]: Os melhores players online do servidor se encontram em: /MELHORES",
"[DICA]: Você pode bloquear PM's de um player específico: /bloquear <id ou nick>",
"[DICA]: Para ler sua última PM recebida, digite: /UPM",
"[DICA]: Não quer ser banido? Não descumpra as /regras",
"[DICA]: Jamais saia do jogo com life baixo, pode ser pego pelo sistema (RQ)",
"[DICA]: Você pode usar o Anti-GPS por $15000: /AGPS",
"[DICA]: Você pode nascer com colete: /NCC",
"[DICA]: Você pode nascer com Kit Walk: /NKW",
"[DICA]: Você pode nascer com Kit Guerra: /NCK",
"[DICA]: Você pode fazer veículos pelo nome: /VM",
"[DICA]: Lag? Sem placa de vídeo? Experimente: /SL",
"[DICA]: /SL não esta resolvendo? Experimente: /TXOFF",
"[DICA]: Você pode mudar seu clima: /MT",
"[DICA]: Lista de anims em: /ANIMLIST",
"[DICA]: Escolha qualquer local como spawn: /MSP",
"[DICA]: Obtenha um paraquedas: /PARAQUEDAS",
"[DICA]: Você pode puxar seu veículo digitando: /TMV",
"[DICA]: Belas cores e efeitos em: /PINTAR",
"[DICA]: Tune seu carro aleatoriamente: /AT",
"[DICA]: Deixe seu carro com efeitos especiais: /PINTAR",
"[DICA]: Divirta-se colocando acessórios: /AC",
"[DICA]: Divirta-se com Hydras: /MD",
"[DICA]: Você pode escolher qualquer lugar para nascer: /MSP",
"[DICA]: Emoção total: /RM",
"[DICA]: Nova pista de drift: /DRIFT",
"[DICA]: Novos stunts em: /AEROLV e /AEROLS",
"[DICA]: Nosso grupo no facebook: www.facebook.com/groups/mundodospikas/",
"[DICA]: Nas missões nenhum comando funciona, nem o /GC",
"[DICA]: Consiga dinheiro fazendo pequenas missões: /MIS",
"[DICA]: Quanto mais lento o veículo, mais lucro tem as missões!",
"[DICA]: Você pode mudar seu nick sem perder nada: /MUDARNICK",
"[DICA]: Sistema de GPS: /GPS",
"[DICA]: Muita emoção no: /DROP",
"[DICA]: Ações especiais de festas: /FESTA",
"[DICA]: Treine sua defesa pessoal desarmado: /ACADEMIA",
"[DICA]: Lute melhor, trocando o estilo do SKIN: /ACADEMIA",
"[DICA]: Fale usando o chat proximo iniciando a frase com o simbolo ;",
"[DICA]: Você pode bloquear PMs digitando: /BPM",
"[DICA]: Hellikills são proibidos, exceto no Mundo da Guerra",
"[DICA]: Compre armas rapidamente: /KITS",
"[DICA]: Compre armas rapidamente: /ARMAS",
"[DICA]: Você pode alterar sua senha: /MUDARSENHA <NOVA SENHA>",
"[DICA]: Saiba quantos ADMINS estão online agora: /ADMINS",
"[DICA]: No AMMUNATION de LV tem armas e colete grátis.",
"[DICA]: Faça qualquer veículo através do MENU: /CS",
"[DICA]: Nitro Infinito: Mantenha pressionado CTRL ou CLICK",
"[DICA]: Tente matar com armas difíceis, ganhará bônus",
"[DICA]: Cada jogador que você matar, ganhará +1 de SCORE",
"[DICA]: Existem 207 propriedades, você pode ser dono de 20!",
"[DICA]: As propriedades são permanentemente suas por 30 minutos",
"[DICA]: Regras do servidor: /regras",
"[DICA]: Comandos para veículos: /carros ou /v",
"[DICA]: Mude seu skin: /MS [ID]",
"[DICA]: Se ficar de ESC no meio de batalha ou X1 sera kickado!",
"[DICA]: Mude a cor de seu nick: /MC",
"[DICA]: Mude a sua cor, temos 300 cores disponiveis: /MC",
"[DICA]: Pintura e efeitos especiais: /PINTAR",
"[DICA]: Mude seu SKIN (personagem): /MS",
"[DICA]: Derrube facilmente helicópteros: /rojao",
"[DICA]: Compre kits e equipamentos: /kits",
"[DICA]: Compre kits e equipamentos: /ARMAS",
"[DICA]: Colabore com a administração, se ver um cheater, use /report",
"[DICA]: Cheater? ---> /report <id> <motivo>",
"[DICA]: Alguém roubou seu carro? Recupere agora mesmo: /MV",
"[DICA]: Teleporte-se para seu veículo: /MV",
"[DICA]: Conhece o ponto mais alto de Mundo dos Pikas? ---> /TOPO",
"[DICA]: Conhece as montanhas de San Fierro? ---> /EXSF",
"[DICA]: Você pode trancar seu veículo: /trancar ou /destrancar",
"[DICA]: Use o /report <id> <motivo> e denucie cheaters anonimamente.",
"[INFO]: Mundo dos Pikas ---> Te divertindo desde Junho/2015!",
"[INFO]: Quer andar de barco? Vá ao /barco e navegue até a ILHA",
"[DICA]: NITRO --> Mantenha pressionado o botão esquerdo do mouse.",
"[DICA]: Atalhos rápidos: ( /carro = /c ) ( carros = /cs )",
"[DICA]: Faça qualquer tipo de carro do jogo: /CS",
"[DICA]: Tem alguem indesejavel dentro do seu carro? /ejetar",
"[DICA]: Esta em um local alto e deseja pular? /paraquedas",
"[DICA]: Desvire seu carro usando /flip",
"[DICA]: A cada re-spawn voce nasce com armas aleatórias",
"[DICA]: Os re-spawns são em lugares aleatórios em Las Venturas",
"[DICA]: Se ver um cheater use o /report não diga diretamente no chat.",
"[DICA]: Antes de acusar alguem de cheater, leve em consideração o LAG do player.",
"[DICA]: Você está jogando: Mundo dos Pikas ( /creditos )",
"[DICA]: Fique por dentro das regras: /regras",
"[DICA]: Ativar/Desativar GODCAR: /gc",
"[DICA]: Teleporte para Las Venturas: /lv",
"[DICA]: Compre propriedades ficando sobre o icone verde e digite /comprar",
"[DICA]: Venda suas propriedades ficando sobre o icone verde e digite /vender",
"[DICA]: Veja sua lista de propriedades /minhasprops",
"[DICA]: Saiba todos os comandos: /comandos",
"[DICA]: Registre e salve seus status e propriedades! /registrar",
"[DICA]: Reporte cheaters: /report ID MOTIVO",
"[DICA]: Saiba o que é proibido, para não ser banido: /regras",
"[DICA]: Venha e tome uma /cerveja com a gente no /bar",
"[DICA]: Divirta-se matando com MINIGUN! /MG",
"[DICA]: Divirta-se matando com BAZUCA! /BZ",
"[DICA]: Para mais informações entre em nosso grupo no Facebook.",
"[DICA]: Vamos beber todas! /BAR",
"[DICA]: Saiba a hora certa: /HORAS",
"[DICA]: Quer mais privacidade? Use o chat próximo: ;",
"[DICA]: Chat entre players a 20 metros de você: ;",
"[DICA]: Saiba o status dos players apertando TAB e clicando nos nicks!",
"[DICA]: Nosso grupo: www.facebook.com/groups/1104937692859642/"};

new playerColors[500] = {
0xFF8C13AA,0xC715FFAA,0x20B2AAAA,0xDC143CAA,0x6495EDAA,0xf0e68cAA,0x778899AA,0xFF1493AA,0xF4A460AA,0xEE82EEAA,0xFFD720AA,
0x8b4513AA,0x4949A0AA,0x148b8bAA,0x14ff7fAA,0x556b2fAA,0x0FD9FAAA,0x10DC29AA,0x534081AA,0x0495CDAA,0xEF6CE8AA,0xBD34DAAA,
0x247C1BAA,0x0C8E5DAA,0x635B03AA,0xCB7ED3AA,0x65ADEBAA,0x5C1ACCAA,0xF2F853AA,0x11F891AA,0x7B39AAAA,0x53EB10AA,0x54137DAA,
0x275222AA,0xF09F5BAA,0x3D0A4FAA,0x22F767AA,0xD63034AA,0x9A6980AA,0xDFB935AA,0x3793FAAA,0x90239DAA,0xE9AB2FAA,0xAF2FF3AA,
0x057F94AA,0xB98519AA,0x388EEAAA,0x028151AA,0xA55043AA,0x0DE018AA,0x93AB1CAA,0x95BAF0AA,0x369976AA,0x18F71FAA,0x4B8987AA,
0x491B9EAA,0x829DC7AA,0xBCE635AA,0xCEA6DFAA,0x20D4ADAA,0x2D74FDAA,0x3C1C0DAA,0x12D6D4AA,0x48C000AA,0x2A51E2AA,0xE3AC12AA,
0xFC42A8AA,0x2FC827AA,0x1A30BFAA,0xB740C2AA,0x42ACF5AA,0x2FD9DEAA,0xFAFB71AA,0x05D1CDAA,0xC471BDAA,0x94436EAA,0xC1F7ECAA,
0xCE79EEAA,0xBD1EF2AA,0x93B7E4AA,0x3214AAAA,0x184D3BAA,0xAE4B99AA,0x7E49D7AA,0x4C436EAA,0xFA24CCAA,0xCE76BEAA,0xA04E0AAA,
0x9F945CAA,0xDCDE3DAA,0x10C9C5AA,0x70524DAA,0x0BE472AA,0x8A2CD7AA,0x6152C2AA,0xCF72A9AA,0xE59338AA,0xEEDC2DAA,0xD8C762AA,
0x3FE65CAA,0xFF8C13AA,0xC715FFAA,0x20B2AAAA,0xDC143CAA,0x6495EDAA,0xf0e68cAA,0x778899AA,0xFF1493AA,0xF4A460AA,0xEE82EEAA,0xFFD720AA,
0x8b4513AA,0x4949A0AA,0x148b8bAA,0x14ff7fAA,0x556b2fAA,0x0FD9FAAA,0x10DC29AA,0x534081AA,0x0495CDAA,0xEF6CE8AA,0xBD34DAAA,
0x247C1BAA,0x0C8E5DAA,0x635B03AA,0xCB7ED3AA,0x65ADEBAA,0x5C1ACCAA,0xF2F853AA,0x11F891AA,0x7B39AAAA,0x53EB10AA,0x54137DAA,
0x275222AA,0xF09F5BAA,0x3D0A4FAA,0x22F767AA,0xD63034AA,0x9A6980AA,0xDFB935AA,0x3793FAAA,0x90239DAA,0xE9AB2FAA,0xAF2FF3AA,
0x057F94AA,0xB98519AA,0x388EEAAA,0x028151AA,0xA55043AA,0x0DE018AA,0x93AB1CAA,0x95BAF0AA,0x369976AA,0x18F71FAA,0x4B8987AA,
0x491B9EAA,0x829DC7AA,0xBCE635AA,0xCEA6DFAA,0x20D4ADAA,0x2D74FDAA,0x3C1C0DAA,0x12D6D4AA,0x48C000AA,0x2A51E2AA,0xE3AC12AA,
0xFC42A8AA,0x2FC827AA,0x1A30BFAA,0xB740C2AA,0x42ACF5AA,0x2FD9DEAA,0xFAFB71AA,0x05D1CDAA,0xC471BDAA,0x94436EAA,0xC1F7ECAA,
0xCE79EEAA,0xBD1EF2AA,0x93B7E4AA,0x3214AAAA,0x184D3BAA,0xAE4B99AA,0x7E49D7AA,0x4C436EAA,0xFA24CCAA,0xCE76BEAA,0xA04E0AAA,
0x9F945CAA,0xDCDE3DAA,0x10C9C5AA,0x70524DAA,0x0BE472AA,0x8A2CD7AA,0x6152C2AA,0xCF72A9AA,0xE59338AA,0xEEDC2DAA,0xD8C762AA,
0x3FE65CAA,0xFF8C13AA,0xC715FFAA,0x20B2AAAA,0xDC143CAA,0x6495EDAA,0xf0e68cAA,0x778899AA,0xFF1493AA,0xF4A460AA,0xEE82EEAA,0xFFD720AA,
0x8b4513AA,0x4949A0AA,0x148b8bAA,0x14ff7fAA,0x556b2fAA,0x0FD9FAAA,0x10DC29AA,0x534081AA,0x0495CDAA,0xEF6CE8AA,0xBD34DAAA,
0x247C1BAA,0x0C8E5DAA,0x635B03AA,0xCB7ED3AA,0x65ADEBAA,0x5C1ACCAA,0xF2F853AA,0x11F891AA,0x7B39AAAA,0x53EB10AA,0x54137DAA,
0x275222AA,0xF09F5BAA,0x3D0A4FAA,0x22F767AA,0xD63034AA,0x9A6980AA,0xDFB935AA,0x3793FAAA,0x90239DAA,0xE9AB2FAA,0xAF2FF3AA,
0x057F94AA,0xB98519AA,0x388EEAAA,0x028151AA,0xA55043AA,0x0DE018AA,0x93AB1CAA,0x95BAF0AA,0x369976AA,0x18F71FAA,0x4B8987AA,
0x491B9EAA,0x829DC7AA,0xBCE635AA,0xCEA6DFAA,0x20D4ADAA,0x2D74FDAA,0x3C1C0DAA,0x12D6D4AA,0x48C000AA,0x2A51E2AA,0xE3AC12AA,
0xFC42A8AA,0x2FC827AA,0x1A30BFAA,0xB740C2AA,0x42ACF5AA,0x2FD9DEAA,0xFAFB71AA,0x05D1CDAA,0xC471BDAA,0x94436EAA,0xC1F7ECAA,
0xCE79EEAA,0xBD1EF2AA,0x93B7E4AA,0x3214AAAA,0x184D3BAA,0xAE4B99AA,0x7E49D7AA,0x4C436EAA,0xFA24CCAA,0xCE76BEAA,0xA04E0AAA,
0x9F945CAA,0xDCDE3DAA,0x10C9C5AA,0x70524DAA,0x0BE472AA,0x8A2CD7AA,0x6152C2AA,0xCF72A9AA,0xE59338AA,0xEEDC2DAA,0xD8C762AA,
0x3FE65CAA,0xFF8C13AA,0xC715FFAA,0x20B2AAAA,0xDC143CAA,0x6495EDAA,0xf0e68cAA,0x778899AA,0xFF1493AA,0xF4A460AA,0xEE82EEAA,0xFFD720AA,
0x8b4513AA,0x4949A0AA,0x148b8bAA,0x14ff7fAA,0x556b2fAA,0x0FD9FAAA,0x10DC29AA,0x534081AA,0x0495CDAA,0xEF6CE8AA,0xBD34DAAA,
0x247C1BAA,0x0C8E5DAA,0x635B03AA,0xCB7ED3AA,0x65ADEBAA,0x5C1ACCAA,0xF2F853AA,0x11F891AA,0x7B39AAAA,0x53EB10AA,0x54137DAA,
0x275222AA,0xF09F5BAA,0x3D0A4FAA,0x22F767AA,0xD63034AA,0x9A6980AA,0xDFB935AA,0x3793FAAA,0x90239DAA,0xE9AB2FAA,0xAF2FF3AA,
0x057F94AA,0xB98519AA,0x388EEAAA,0x028151AA,0xA55043AA,0x0DE018AA,0x93AB1CAA,0x95BAF0AA,0x369976AA,0x18F71FAA,0x4B8987AA,
0x491B9EAA,0x829DC7AA,0xBCE635AA,0xCEA6DFAA,0x20D4ADAA,0x2D74FDAA,0x3C1C0DAA,0x12D6D4AA,0x48C000AA,0x2A51E2AA,0xE3AC12AA,
0xFC42A8AA,0x2FC827AA,0x1A30BFAA,0xB740C2AA,0x42ACF5AA,0x2FD9DEAA,0xFAFB71AA,0x05D1CDAA,0xC471BDAA,0x94436EAA,0xC1F7ECAA,
0xCE79EEAA,0xBD1EF2AA,0x93B7E4AA,0x3214AAAA,0x184D3BAA,0xAE4B99AA,0x7E49D7AA,0x4C436EAA,0xFA24CCAA,0xCE76BEAA,0xA04E0AAA,
0x9F945CAA,0xDCDE3DAA,0x10C9C5AA,0x70524DAA,0x0BE472AA,0x8A2CD7AA,0x6152C2AA,0xCF72A9AA,0xE59338AA,0xEEDC2DAA,0xD8C762AA,
0x3FE65CAA,0xFF8C13AA,0xC715FFAA,0x20B2AAAA,0xDC143CAA,0x6495EDAA,0xf0e68cAA,0x778899AA,0xFF1493AA,0xF4A460AA,0xEE82EEAA,0xFFD720AA,
0x8b4513AA,0x4949A0AA,0x148b8bAA,0x14ff7fAA,0x556b2fAA,0x0FD9FAAA,0x10DC29AA,0x534081AA,0x0495CDAA,0xEF6CE8AA,0xBD34DAAA,
0x247C1BAA,0x0C8E5DAA,0x635B03AA,0xCB7ED3AA,0x65ADEBAA,0x5C1ACCAA,0xF2F853AA,0x11F891AA,0x7B39AAAA,0x53EB10AA,0x54137DAA,
0x275222AA,0xF09F5BAA,0x3D0A4FAA,0x22F767AA,0xD63034AA,0x9A6980AA,0xDFB935AA,0x3793FAAA,0x90239DAA,0xE9AB2FAA,0xAF2FF3AA,
0x057F94AA,0xB98519AA,0x388EEAAA,0x028151AA,0xA55043AA,0x0DE018AA,0x93AB1CAA,0x95BAF0AA,0x369976AA,0x18F71FAA,0x4B8987AA,
0x491B9EAA,0x829DC7AA,0xBCE635AA,0xCEA6DFAA,0x20D4ADAA,0x2D74FDAA,0x3C1C0DAA,0x12D6D4AA,0x48C000AA,0x2A51E2AA,0xE3AC12AA,
0xFC42A8AA,0x2FC827AA,0x1A30BFAA,0xB740C2AA,0x42ACF5AA,0x2FD9DEAA,0xFAFB71AA,0x05D1CDAA,0xC471BDAA,0x94436EAA,0xC1F7ECAA,
0xCE79EEAA,0xBD1EF2AA,0x93B7E4AA,0x3214AAAA,0x184D3BAA,0xAE4B99AA,0x7E49D7AA,0x4C436EAA,0xFA24CCAA,0xCE76BEAA,0xA04E0AAA,
0x9F945CAA,0xDCDE3DAA,0x10C9C5AA,0x70524DAA,0x0BE472AA,0x8A2CD7AA,0x6152C2AA,0xCF72A9AA,0xE59338AA,0xEEDC2DAA,0xD8C762AA,
0x3FE65CAA
};


enum weather_info{wt_id,wt_text[2]};
new gRandomWeatherIDs[][weather_info] ={
{1,"T"},
{2,"T"},
{3,"T"},
{4,"T"},
{5,"T"},
{6,"T"},
{7,"T"},
{10,"T"},
{11,"T"},
{12,"T"},
{13,"T"},
{14,"T"}
};

forward clock(force);
public clock(force){
gettime(GlobalHour2);
if(GlobalHour2 == GlobalHour && force == 0) return 1;
gettime(GlobalHour2);
gettime(GlobalHour);
new hour,minute,second;
gettime(hour,minute,second);
if(AutoCiclo == 1){
if (hour == 0){SetWorldTime(0);}
if (hour == 1){SetWorldTime(1);}
if (hour == 2){SetWorldTime(2);}
if (hour == 3){SetWorldTime(3);}
if (hour == 4){SetWorldTime(4);}
if (hour == 5){SetWorldTime(5);}
if (hour == 6){SetWorldTime(6);}
if (hour == 7){SetWorldTime(7);}
if (hour == 8){SetWorldTime(8);}
if (hour == 9){SetWorldTime(9);}
if (hour == 10){SetWorldTime(10);}
if (hour == 11){SetWorldTime(11);}
if (hour == 12){SetWorldTime(12);}
if (hour == 13){SetWorldTime(13);}
if (hour == 14){SetWorldTime(14);}
if (hour == 15){SetWorldTime(15);}
if (hour == 16){SetWorldTime(16);}
if (hour == 17){SetWorldTime(17);}
if (hour == 18){SetWorldTime(20);}
if (hour == 19){SetWorldTime(23);}
if (hour == 20){SetWorldTime(0);}
if (hour == 21){SetWorldTime(0);}
if (hour == 22){SetWorldTime(0);}
if (hour == 23){SetWorldTime(0);}}

if (hour == 6){ //HORA DA MANUTENÇÃO
CallRemoteFunction("SaveProperties","i","9999999");
for(new v; v<UltimoVeiculoGM; v++)if (GetVehicleDriver(v) == -1){
SetVehicleToRespawn(v);}
SendClientMessageToAll(COLOUR_DICA, "[MANUTENÇÃO RÁPIDA]: Todos os veículos do mapa foram estacionados.");}

//Bom dia, boa tarde, boa noite
if (hour == 9){Tela3Set(10,"Bom Dia!",0);}
if (hour == 13){Tela3Set(10,"Boa Tarde!",0);}
if (hour == 21){Tela3Set(10,"Boa Noite!",0);}

new string[100];
format(string, sizeof(string), "[HORÁRIO]: Mundo dos Pikas informa: são %i:00 horas! [Brasília]", GlobalHour);
SendClientMessageToAll(COLOUR_DICA,string);
return 1;}

new Float:TMissoesDestinosCOO[][3] = {
{-1943.6118,152.6621,25.7109},
{-1036.0621,-1502.9808,73.7998},
{-625.3555,-1139.6056,43.4500},
{-52.2943,-1017.9242,19.3609},
{817.9810,-1369.2091,-1.6788},
{1763.3710,-1953.8518,13.5469},
{2127.5911,-1953.8125,13.5469},
{2206.0320,-1666.0825,14.5596},
{2284.9126,-1164.1584,26.4734},
{2440.9756,-273.0047,18.3616},
{2764.8628,921.6600,10.9554},
{2864.7571,1287.1703,10.8203},
{2781.0142,1838.2689,10.7750},
{2548.9312,2518.8384,10.8203},
{2370.0198,2690.2559,10.8203},
{1919.1721,2694.0610,10.8281},
{1441.3586,2632.2556,10.8203},
{741.0522,1978.5052,5.3426},
{567.4672,1265.0668,11.9868},
{35.2259,1292.3440,18.3114},
{-1700.1118,440.1438,11.4414}};

new TMissoesDestinosTXT[][45] = {
{"San Fierro - Estação Cram Berry"},
{"Flint County - Fazendas"},
{"Flint County - Acampamento"},
{"Flint County - Transportadora"},
{"Los Santos - Estação Market"},
{"Los Santos - Estação Unity"},
{"Los Santos - Porto"},
{"Los Santos - Grove Street"},
{"Los Santos - East"},
{"Red County"},
{"Las Venturas - Rockshore East"},
{"Las Venturas - Estação Linden"},
{"Las Venturas - Sobel Rail Yards"},
{"Las Venturas - Julius ThruWay East"},
{"Las Venturas - Military Aviation Fuel Depot"},
{"Las Venturas - Residencial"},
{"Las Venturas - Estação Yellow Bell"},
{"Las Venturas - Bone County"},
{"Las Venturas - Octane Springs"},
{"Fort Carson"},
{"San Fierro - Easter Basin"}};

new Float:HMissoesDestinosCOO[][3] = {
{1964.6560,1916.8076,130.9375},
{2093.8923,2407.3462,74.5786},
{2281.7427,2445.3206,46.9775},
{2618.0740,2721.7197,36.5386},
{2621.6316,2437.2361,14.8672},
{2384.3127,1136.0404,34.2529},
{1544.0881,-1353.5482,329.4739},
{1560.0892,-1645.8735,28.4021},
{1291.3315,-788.4116,96.4609},
{365.3591,2537.0725,16.6648},
{-1821.9553,551.6089,234.8874},
{-2562.5779,646.8237,27.8062},
{-2319.7822,1545.3296,18.7734},
{-1458.4991,501.9448,18.2699}};

new HMissoesDestinosTXT[][45] = {
{"Las Venturas - Visage Hotel"},
{"Las Venturas - Hotel Emerald"},
{"Las Venturas - Delegacia"},
{"Las Venturas - Military Aviation Fuel Depot"},
{"Las Venturas - VRock Hotel"},
{"Las Venturas - Prefeitura"},
{"Los Santos - DownTown"},
{"Los Santos - Delegacia"},
{"Los Santos - Mansão do MadDog"},
{"Aeroporto Abandonado"},
{"San Fierro"},
{"San Fierro - Medical Center"},
{"San Fierro - Navio"},
{"San Fierro - Navio do Exército"}};

new Float:AMissoesDestinosCOO[][3] = {
{-1224.8468,267.8392,14.1484},
{1717.4225,-2493.7810,13.5547},
{308.2419,1930.0522,17.6406},
{220.6316,2505.1511,16.4844},
{1477.5365,1515.3896,10.8281}};

new AMissoesDestinosTXT[][45] = {
{"San Fierro - Aeroporto"},
{"Los Santos - Aeroporto"},
{"Area 51 - Pista de pouso"},
{"Deserto - Aeroporto Abandonado"},
{"Las Venturas - Aeroporto"}};

new Float:VMissoesDestinosCOO[][3] = {
{1654.1470,1625.9491,10.8203},
{2401.1951,-2546.4143,13.6491},
{1913.2782,621.7333,10.4170},
{2183.3325,919.9706,10.5071},
{2313.6802,2459.7351,10.5064},
{1659.0334,1625.8947,10.5065},
{389.0191,2540.9958,16.2363},
{133.8631,1943.8474,19.9421},
{263.5122,1406.5366,10.1818},
{-162.2401,1228.6510,19.4257},
{834.4963,871.4468,12.8397},
{1245.7936,-787.5256,89.7755},
{1569.5488,-1611.2968,13.0673},
{2497.0059,-1664.4579,13.0414},
{-1048.7755,-1198.8040,128.6871},
{321.1817,-1798.1620,4.3762},
{-929.4506,2028.5421,60.6033},
{-1991.0237,141.3557,27.2388},
{-2047.2592,-97.2964,34.8661},
{-2645.2952,1368.7845,6.8615},
{-1637.1296,1200.9398,6.8681},
{-1614.5895,663.9761,6.8840},
{-1707.3674,54.6090,3.2345},
{-1511.7314,-311.3242,6.3040},
{1834.2776,-2431.7078,13.2368},
{-2289.7925,-1639.4547,483.3463},
{-2796.6350,-1522.7964,138.8928},
{-1522.5449,2632.2510,55.5309},
{-2196.2539,-2436.7339,30.3214},
{2127.2917,2360.0232,10.5186},
{2169.2651,1846.6195,10.5093},
{2057.9702,842.6888,6.3943},
{2601.8625,2262.6421,10.5016},
{2494.2214,2773.4255,10.4996},
{-97.3865,1086.0754,19.4283},
{-183.7285,1132.4846,19.4266},
{-371.2281,1577.3890,75.7279},
{-2479.5498,-616.4517,132.2592},
{-2044.5295,55.6910,28.0784},
{-1228.0712,446.7257,6.9130},
{-2126.9797,-396.8940,35.0324},
{62.8007,-266.5696,1.2523},
{-85.6187,-65.6069,2.8121},
{1348.5139,348.2737,19.7623},
{1281.8584,368.0219,19.1607},
{1246.7180,336.5432,19.2390},
{2341.8943,63.4064,26.0199},
{2261.2261,-84.2968,26.2012},
{2340.8455,151.2650,26.0182},
{663.7414,-453.7268,16.0208},
{615.2716,-588.5300,16.9206},
{658.4041,-564.5905,16.0303},
{-2453.0222,2302.2803,4.6636},
{1275.5917,-2022.4944,58.6621},
{1359.3677,-1279.9431,13.0368},
{2095.4785,-1797.3337,13.0682},
{1778.8385,-1914.5453,13.0712},
{1825.1943,-1682.0988,13.0765},
{1505.0095,2867.8208,10.5071},
{1835.6049,2793.7810,10.5226},
{-823.4736,1436.0078,13.7891},
{-804.8754,1557.8469,26.9609},
{-745.4327,1576.5457,26.9609},
{2286.8350,606.7845,10.8203},
{2817.2976,1325.4070,10.7537},
{1721.8099,2318.9585,10.8203},
{1725.0018,2218.1099,10.6719},
{1165.1274,1439.8193,5.8203},
{1137.3877,1371.0850,10.6719},
{992.0604,1122.9165,10.8203},
{1364.2056,1090.5991,10.8203}};

new VMissoesDestinosTXT[][45] = {
{"Las Venturas - Aeroporto"},
{"Los Santos - Porto"},
{"Las Venturas - Hospital"},
{"Las Venturas - Ammunation"},
{"Las Venturas - Delegacia"},
{"Las Venturas - Aeroporto"},
{"Aeroporto Abandonado"},
{"Deserto - Area 51"},
{"Deserto - Refinaria"},
{"Fort Carson - King Ring"},
{"Las Venturas - Mineradora"},
{"Los Santos - Mansao MadDog"},
{"Los Santos - Delegacia"},
{"Los Santos - Grove Street"},
{"A Fazenda"},
{"Los Santos - Praia"},
{"Deserto - Represa"},
{"San Fierro - Estacao"},
{"San Fierro - Auto Escola"},
{"San Fierro - Puteiro"},
{"San Fierro - Concessionaria"},
{"San Fierro - Delegacia"},
{"San Fierro - Porto"},
{"San Fierro - Aeroporto"},
{"Los Santos - Aeroporto"},
{"Monte Chilliad (Topo)"},
{"Monte Chilliad (Cabana)"},
{"El Quebrados - Ammunation"},
{"Angel Pine - Deposito"},
{"Las Venturas - Hotel Emerald"},
{"Las Venturas - Clowns Pocket"},
{"Las Venturas - Avenida"},
{"Las Venturas - VRock Hotel"},
{"Las Venturas - Military Aviation Fuel Depot"},
{"Fort Carson - Radio"},
{"Fort Carson - Banco"},
{"The Big Ear"},
{"San Fierro - Emissora de TV"},
{"San Fierro - Bombeiros"},
{"San Fierro - Exercito"},
{"San Fierro - Corvin Stadium"},
{"Blue Berry"},
{"Blue Berry - Acres"},
{"Montgomery - Bio Engineering"},
{"Montgomery - Papercuts"},
{"Montgomery - Crippen Memorial"},
{"Palomino Creek - Ammunation"},
{"Palomino Creek - Biblioteca"},
{"Palomino Creek - Residencial"},
{"Dillimore - Barbearia"},
{"Dillimore - Delegacia"},
{"Dillimore - Posto"},
{"Bayside - Galpao"},
{"Los Santos - Mansao"},
{"Los Santos - Ammunation"},
{"Los Santos - Pizzaria Grove"},
{"Los Santos - Estacao"},
{"Los Santos - Danceteria Alhambra"},
{"Las Venturas - Condominio"},
{"Las Venturas - Clube de Golf"},
{"Las Barrancas - Tee Pee Motel"},
{"Las Barrancas - Igreja"},
{"Las Barrancas - Tradding Post"},
{"Las Venturas - Marina"},
{"Las Venturas - Estação Linden"},
{"Las Venturas - RedSands West"},
{"Las Venturas - SteakHouse"},
{"Las Venturas - Dirt Ring"},
{"Las Venturas - Turning Trick"},
{"Las Venturas - Faculdade"},
{"Las Venturas - Estação de Cargas"}};

//VELOCIMETRO
new Text: TXTVELOCIDADE[MAX_PLAYERS];

forward AutoGodConnect(playerid);
forward GodCar();
forward Kickar(playerid);
forward SetupPlayerForClassSelection(playerid);
forward GameModeExitFunc();
forward SendPlayerFormattedText(playerid, COLOR, const str[], define);
forward SendAllFormattedText(COLOR, const str[], define);


new Float:PVC_CARROS[][4] = {
{1253.8004,-1379.7913,13.1834,358.7227},
{1261.2432,-1379.8154,13.1911,0.0727},
{1342.3043,-1420.8325,13.3828,174.8745},
{538.0486,-1432.9948,15.8460,181.1914},
{529.3641,-1433.4598,15.8517,181.3141},
{523.9241,-1398.5326,15.9588,13.7606}};

new Float:PVC_PLAYERS[][4] = {
{858.21478,-1409.66418,42.95850,91.00000},
{852.97192,-1409.80005,42.95850,91.00000},
{858.14960,-1394.83386,42.95850,91.00000},
{852.94531,-1394.72437,42.95850,91.00000}};

new Float:PL_POLICIA[][4] = {
{-1635.4963,663.7042,7.1875,261.8802},
{-1616.5702,685.3682,7.1875,91.2164},
{-1576.9122,683.9076,7.1875,179.3683},
{-1605.3922,713.0695,13.6848,3.4010},
{-1665.2134,681.8090,14.7078,267.8337}};

new Float:PL_LADRAO[][4] = {
{-1654.8820,-19.2837,3.5673,47.6255},
{-1685.8813,-46.4774,3.5636,39.6876},
{-1703.4792,-81.2652,3.5618,39.1653},
{-1697.0897,-9.8524,3.5547,151.5485},
{-1619.5410,-50.5893,3.5610,52.6388}};

new Float:DelegaciaPos[][4] = {
{238.3328,143.1916,1003.0234,356.8433},
{191.5408,158.1473,1003.0234,269.5832},
{192.0420,179.2812,1003.0234,266.1927},
{211.0461,186.2120,1003.0313,178.2014},
{228.6800,182.0748,1003.0313,143.3728},
{246.6956,186.8552,1008.1719,357.8633},
{298.6707,172.2754,1007.1719,56.5133},
{299.0335,191.3990,1007.1794,92.2897},
{267.7694,186.6704,1008.1719,357.9837},
{257.7439,186.7893,1008.1719,1.2777},
{246.1298,143.9220,1003.0234,41.8335},
{229.6117,171.5647,1003.0321,88.9947},
{198.7001,168.3521,1003.0234,272.0722}};

new Float:CheckpointEAM[][3] = {
{1590.4913,1818.9327,10.8203},
{2035.0171,-1405.8237,17.2241},
{186.3096,1411.0170,10.5859},
{-2465.8977,2237.2998,4.7942},
{-2706.3147,376.0271,4.9687},
{-1951.2992,642.9045,46.5625},
{-2664.8335,624.0929,14.4531}};

new Float:AAD_CASA_SPAWNS[][4] = {
{-2185.5583,-263.6050,36.5156,1.6144},
{-2185.5583,-263.6050,36.5156,1.6144},
{-2173.2891,-262.1146,36.5156,349.7076},
{-2161.8149,-261.8016,36.5156,12.8945},
{-2153.8059,-260.8839,36.5156,356.6010},
{-2143.9333,-261.2535,36.5156,354.7210},
{-2149.1968,-251.6652,36.5156,6.6278},
{-2161.4058,-251.6493,36.5156,9.7611},
{-2170.8030,-250.7980,36.5156,286.4136},
{-2143.5493,-249.2430,36.5156,46.7348},
{-2143.2278,-234.1199,36.5156,67.4149},
{-2159.4326,-236.8994,36.5156,20.4145},
{-2171.6077,-233.3183,36.5156,349.7076},
{-2182.1221,-235.2665,36.5220,3.4943},
{-2185.8340,-231.1575,36.5156,322.7606},
{-2186.6497,-222.4561,36.5156,289.5470},
{-2186.1250,-210.6063,36.5156,280.1469},
{-2186.0723,-206.1493,36.5156,250.6933},
{-2188.9124,-238.7917,36.5220,299.8637},
{-2177.9773,-237.2060,36.5220,326.8106},
{-2165.1016,-224.2348,36.5156,333.0773},
{-2178.1077,-222.5904,36.5156,312.6871},
{-2167.9951,-242.1403,40.7195,277.8834},
{-2177.2915,-242.9925,40.7195,199.2594},
{-2183.4895,-244.6649,40.7195,275.7134},
{-2182.8665,-250.6636,40.7195,271.3267}};

new Float:AAD_PORTAO_SPAWNS[][4] = {
{-2136.1946,-95.0814,35.3203,179.8794},
{-2130.4343,-96.3455,35.3203,176.1194},
{-2123.9470,-97.8259,35.3203,176.7461},
{-2118.6057,-97.7501,35.3203,176.7461},
{-2112.3623,-99.3928,35.3203,176.7461},
{-2105.0439,-100.1913,35.3203,189.2795},
{-2104.2117,-93.3767,35.3273,176.4561},
{-2110.9885,-91.8766,35.3203,180.8428},
{-2119.7830,-93.1021,35.3203,180.8428},
{-2128.4163,-94.5516,35.3203,180.8428},
{-2133.9473,-90.3185,35.3203,167.0560},
{-2125.5068,-91.8195,35.3203,177.0827},
{-2117.7659,-92.7950,35.3203,175.2027},
{-2110.6855,-92.8877,35.3203,175.2027},
{-2112.9709,-86.2668,35.3203,158.9092},
{-2120.5603,-85.5288,35.3203,181.4695},
{-2127.4055,-85.9662,35.3203,181.4695},
{-2133.1504,-86.0101,35.3203,181.4695},
{-2137.0930,-86.7678,35.3203,181.4695},
{-2116.2798,-106.6708,35.3203,171.4427},
{-2122.6711,-106.8969,35.3203,183.9762},
{-2128.3821,-107.7689,35.3203,183.9762},
{-2133.4536,-107.3732,35.3273,183.9762},
{-2137.8506,-108.4725,35.3273,183.9762},
{-2145.6436,-105.4724,35.3203,180.8428}};

new Float:MDSpawns_AEROAB[][4] = {
{418.4630,2525.0339,16.4957,92.5147},
{393.2268,2523.9258,16.4844,92.5147},
{360.6817,2525.1851,16.6406,92.5147},
{312.0972,2523.1423,16.7456,92.5147},
{241.3227,2522.0823,16.7041,92.5147}};

new Float:MDSpawns_A51[][4] = {
{288.0481,2036.3523,17.6406,189.4900},
{288.2840,2012.9498,17.6406,178.8365},
{288.2468,2003.1410,17.6406,178.8365},
{288.1694,1976.0204,17.6406,178.8365},
{326.1240,2070.2461,17.6406,144.7063}};

new Float:MDSpawns_REST[][4] = {
{-543.8317,2569.1846,53.5156,7.8017},
{-543.7274,2582.3066,53.5156,5.2950},
{-543.3245,2593.4819,53.5156,0.9083},
{-543.4922,2604.0608,53.5156,0.9083},
{-543.3912,2617.7744,53.5156,0.9083}};

new Float:MDSpawns_SD[][4] = {
{-828.8437,1973.0178,7.0000,187.9467},
{-826.0308,1952.8678,7.0000,187.9467},
{-820.4625,1922.6757,7.0000,187.9467},
{-811.5560,1878.9054,7.0000,187.9467},
{-803.4095,1834.7755,7.0000,187.9467}};

new Float:AeroABPos[][4] = {
{426.0770,2501.6980,16.4844,90.7143},
{386.5242,2540.8762,16.5391,180.6652},
{416.3707,2556.6863,16.3969,93.5577},
{460.1367,2502.3325,21.4104,91.0510},
{364.2841,2462.0925,16.4844,358.9302},
{420.7278,2440.6812,16.5000,3.3167},
{387.3028,2438.5696,16.5000,357.0500},
{405.0951,2438.9756,16.5000,0.4734}};

new Float:WalkPos[][4] = {
{1414.8188,-44.8003,1001.9230,54.1957},
{1415.2163,-26.5803,1001.9257,75.7926},
{1363.6201,3.1735,1001.9219,240.9209},
{1365.7781,-20.7835,1001.9219,273.5079},
{1365.1522,-45.1375,1001.9185,312.0482},
{1386.7091,-25.5297,1001.9216,278.5214}};

new Float:CacarPos[][4] = {
{-1182.3877,-962.2108,129.2119,359.6591},
{-1193.5464,-959.2059,129.2188,273.0740},
{-1195.1123,-984.5573,133.7284,355.7874},
{-1194.1877,-995.3967,129.2188,268.0050},
{-1190.5168,-1058.1276,134.2932,335.4286},
{-1143.6851,-1050.7622,129.2188,0.1824},
{-1143.5033,-1051.8689,129.2188,1.6281},
{-1108.3500,-1059.4937,129.2188,8.7304},
{-1082.5782,-1051.1752,129.2119,55.4177},
{-1075.7267,-1036.5328,129.2188,325.2811},
{-1042.5834,-1015.6590,129.4219,181.6919},
{-1072.6487,-920.3289,129.2188,133.3915},
{-1097.6144,-987.0921,129.2188,92.5301},
{-1094.4209,-987.9362,129.2188,265.8051},
{-1126.2798,-1007.7201,129.2188,353.2587},
{-1162.8969,-944.3861,129.2188,276.6598},
{-1128.2346,-935.8704,129.2188,215.2460},
{-1090.9167,-927.6876,129.2188,291.0732},
{-1065.9667,-996.1892,129.2188,267.7819},
{-1100.4930,-996.8041,129.2188,89.2847},
{-1109.7280,-1047.5098,129.2119,4.9972}};

new Float:DerbyPos[][4] = {
{-1403.6704,953.6288,1027.2029,6.8888},
{-1473.5583,997.9678,1025.9463,266.4333},
{-1398.7191,1039.4536,1029.2161,184.5481},
{-1311.0647,993.3434,1027.8583,89.3566}};

new Float:RunPos[][4] = {
{212.7931,539.4971,22.2255,49.4959},
{245.6183,539.8906,22.2255,86.4462},
{211.2990,570.1185,22.2255,183.2672},
{181.1409,537.2495,22.2255,277.2682},
{214.5207,508.8002,22.2255,358.1095}};

new Float:SniperPos[][4] = {
{2692.6560,2790.9929,59.0234,103.3096},
{2700.0010,2803.7383,45.8672,106.7797},
{2632.5381,2832.3447,127.5781,192.2579},
{2688.9187,2704.8506,28.1563,72.5634},
{2688.1978,2689.3718,28.1563,98.8837},
{2730.6550,2686.0139,59.0234,83.2167},
{2615.7104,2785.0015,10.8203,268.5007},
{2501.8643,2808.1982,14.8222,270.3809},
{2511.5403,2850.3057,14.8222,184.5269},
{2689.2131,2649.3801,37.9970,66.1207},
{2659.4592,2662.6985,37.9184,1.5735},
{2612.5037,2658.1167,37.8453,356.5601},
{2570.3828,2659.2058,37.9258,358.4401},
{2575.5063,2695.7764,28.1406,250.6524},
{2577.4282,2711.8772,28.1953,299.5329},
{2617.7549,2724.2566,36.5386,177.3318},
{2615.5635,2734.6118,23.8222,352.1734},
{2621.6597,2740.7224,30.9056,90.2244},
{2605.6243,2815.9790,27.8203,208.3287},
{2523.8738,2814.6392,24.9536,187.9385},
{2551.3735,2709.5415,10.8203,49.1538},
{2659.1875,2819.1760,38.3222,180.4185},
{2623.4063,2798.4648,10.8203,240.1356},
{2741.6941,2751.4070,14.0722,87.2274},
{2686.9485,2747.2146,20.3222,156.7881},
{2506.1187,2690.8674,77.8438,293.9827},
{2718.4226,2774.0381,77.3594,138.5680},
{2607.8250,2775.0217,23.8222,179.2537},
{2506.7371,2781.3438,10.8203,261.0432}};

new Float:CombatePos[][4] = {
{-2184.1648,-261.7824,40.7195,275.8774},
{-2144.1792,-262.2635,40.7195,90.0924},
{-2185.2026,-247.8433,40.7195,270.5273},
{-2142.5825,-234.2642,36.5156,85.3689},
{-2171.3098,-217.9182,35.3203,275.5875},
{-2150.2390,-148.3051,36.3948,295.0143},
{-2155.0449,-183.7174,41.1297,176.5732},
{-2196.4944,-217.2317,35.3203,357.3916},
{-2128.0530,-277.1054,35.3203,0.1882},
{-2126.9080,-85.4693,35.3203,184.3891},
{-2164.0623,-237.2026,40.3849,0.7739},
{-2100.5540,-154.5885,35.3203,94.1480},
{-2155.3428,-86.5865,35.3203,184.3888},
{-2154.7339,-144.8018,35.3203,180.6288},
{-2100.4028,-198.8599,35.3203,137.0982},
{-2113.5244,-156.2589,41.1297,141.4849},
{-2146.9946,-113.5449,40.8542,179.7120},
{-2186.2090,-209.5053,36.5156,178.4586},
{-2140.9783,-229.4278,40.3849,110.7779},
{-2181.8672,-247.6064,36.5156,275.5927},
{-2185.5422,-262.3193,36.5156,262.7226},
{-2142.3716,-261.0621,36.5156,95.7377},
{-2161.6519,-268.3349,40.7195,356.0967},
{-2158.1819,-268.2909,36.5156,7.6668},
{-2136.6631,-113.6210,35.3273,187.2318},
{-2100.3535,-176.9056,35.3203,58.8106},
{-2149.3191,-184.3031,35.3203,212.4519},
{-2098.8074,-94.4270,35.3273,87.1174},
{-2178.2590,-223.5117,36.5156,314.5996},
{-2146.4531,-138.0573,43.7404,205.1103}};

new Float:BloodySpawns[][4] = {
{2872.6877,2341.5637,11.0625,91.0122},
{2831.2749,2398.2183,11.0625,157.4395},
{2165.7031,2008.7330,10.8203,96.3186},
{2108.9778,2074.6809,10.8203,271.4502},
{2111.0566,2185.1824,10.8203,278.3436},
{2031.4697,1917.4012,12.3359,268.9436},
{1952.7823,1756.8926,20.0393,266.7269},
{1990.8588,1668.1410,22.7734,269.2335},
{1980.8348,1587.2285,22.7734,270.4869},
{2033.6821,1485.2461,10.8203,267.9803},
{2104.4573,1403.8131,11.1328,91.8853},
{2171.1213,1411.7948,11.0625,95.3086},
{2448.8867,1341.0790,10.9766,272.3202},
{2554.8293,1565.1685,10.8203,94.3451},
{2472.4990,1624.4117,11.0157,41.7046},
{2454.8740,2026.4098,11.0625,87.7417},
{2455.2852,2007.8376,11.0625,189.2627},
{2566.3870,2045.5083,11.1094,70.8216},
{2588.2578,2272.5010,11.0625,274.1534},
{2580.2419,2321.4658,17.8222,183.2859},
{2241.7107,2433.5818,10.8203,356.2008},
{2250.6431,2490.7007,10.9908,98.3484},
{2127.7939,2372.8252,10.8203,180.1058},
{2106.3445,2237.8357,11.0234,271.5999},
{2160.5139,2118.2148,10.8203,87.3581},
{2158.4792,2184.4651,10.8203,86.3948},
{2112.2100,1911.0497,10.8203,274.0132},
{2215.9739,1839.2383,10.8203,94.4949},
{2080.3596,1678.3694,10.8203,92.6149},
{2035.0201,1623.6143,10.8297,267.7466},
{2081.7400,1542.6643,10.8203,94.1582},
{2080.5496,1488.2030,10.8203,93.1948},
{2023.4139,1344.3683,10.8203,272.7131},
{2012.1841,1233.5403,10.8203,272.3764},
{2175.2783,1118.4227,12.6653,60.5610},
{2137.7556,1013.3706,10.9766,87.1712},
{2155.4983,961.2625,10.8203,89.6779},
{2155.2185,932.2940,10.8203,94.0646},
{2112.9148,898.7827,11.1797,359.7270},
{2080.6375,865.9565,6.9460,91.2212},
{2033.5934,866.1938,6.9492,274.4995},
{2034.6277,1006.6502,10.8203,271.0295},
{2033.8153,1111.5958,10.8203,274.1628},
{2080.0195,1266.2439,10.8203,93.0545},
{2280.9333,2014.6974,10.8297,2.0936},
{2364.4382,1989.3241,10.8281,89.1544},
{2364.5813,2023.6278,10.8281,95.7110},
{1973.3945,2441.9363,11.1782,223.5055},
{1885.2156,2166.1748,10.8203,190.2451},
{1609.3772,2181.8147,10.8203,358.1466},
{1528.3020,2209.5957,11.2393,271.3291},
{1435.1525,1994.0756,11.0234,2.4398},
{2079.8125,1793.5320,10.8203,247.6187},
{1935.0414,1348.9243,9.9688,274.8557},
{2263.7583,639.5033,10.8203,355.3598},
{2408.3870,643.4951,10.8498,1.6264},
{2080.7473,962.4617,10.6814,89.2671},
{2081.2483,1023.0313,10.8203,84.5431},
{2079.7830,1066.1783,10.8203,91.7270},
{2573.1172,1974.3942,11.1641,268.1052},
{2586.0088,1998.9760,10.8203,197.9179},
{2079.9924,1168.7804,10.8203,88.8836},
//PARTE-LS E SF
{1186.2019,-1324.5498,13.5593,270.5399},
{738.6005,-1337.7101,13.5333,265.6766},
{820.7230,-1365.4579,-0.5078,138.6722},
{808.9805,-1352.5929,13.5414,90.4208},
{1099.5664,-1619.2111,13.6599,86.8746},
{1550.2218,-1675.6875,15.3129,89.7512},
{2496.6113,-1659.8650,13.3359,181.1015},
{1801.6073,-1578.7806,14.0625,266.5233},
{1827.8104,-1682.2711,13.5469,88.0797},
{1653.9413,-1662.7389,22.5156,179.2645},
{1715.8665,-1934.2554,13.5693,176.1230},
{1567.5208,-1890.5551,13.5591,357.4315},
{1151.6139,-2140.3936,68.8765,283.3488},
{1182.6554,-2227.2529,43.9823,188.0675},
{1195.6799,-2344.1094,15.3672,228.2367},
{1474.5359,-2286.7554,42.4205,354.7733},
{-2026.1736,156.7437,29.0391,265.6602},
{-1957.0364,270.4700,41.0471,90.2748},
{-1531.9399,687.4473,133.0514,135.5324}};

new Float:Zones[][GPSInfo] = {
{ "'The Big Ear'",                -410.00,  1403.30,    -3.00,  -137.90,  1681.20,   200.00},
{ "Aldea Malvada",               -1372.10,  2498.50,     0.00, -1277.50,  2615.30,   200.00},
{ "Angel Pine",                  -2324.90, -2584.20,    -6.10, -1964.20, -2212.10,   200.00},
{ "Arco del Oeste",               -901.10,  2221.80,     0.00,  -592.00,  2571.90,   200.00},
{ "Avispa Country Club",         -2646.40,  -355.40,     0.00, -2270.00,  -222.50,   200.00},
{ "Avispa Country Club",         -2831.80,  -430.20,    -6.10, -2646.40,  -222.50,   200.00},
{ "Avispa Country Club",         -2361.50,  -417.10,     0.00, -2270.00,  -355.40,   200.00},
{ "Avispa Country Club",         -2667.80,  -302.10,   -28.80, -2646.40,  -262.30,    71.10},
{ "Avispa Country Club",         -2470.00,  -355.40,     0.00, -2270.00,  -318.40,    46.10},
{ "Avispa Country Club",         -2550.00,  -355.40,     0.00, -2470.00,  -318.40,    39.70},
{ "Back o Beyond",               -1166.90, -2641.10,     0.00,  -321.70, -1856.00,   200.00},
{ "Battery Point",               -2741.00,  1268.40,    -4.50, -2533.00,  1490.40,   200.00},
{ "Bayside",                     -2741.00,  2175.10,     0.00, -2353.10,  2722.70,   200.00},
{ "Bayside Marina",              -2353.10,  2275.70,     0.00, -2153.10,  2475.70,   200.00},
{ "Beacon Hill",                  -399.60, -1075.50,    -1.40,  -319.00,  -977.50,   198.50},
{ "Blackfield",                    964.30,  1203.20,   -89.00,  1197.30,  1403.20,   110.90},
{ "Blackfield",                    964.30,  1403.20,   -89.00,  1197.30,  1726.20,   110.90},
{ "Blackfield Chapel",            1375.60,   596.30,   -89.00,  1558.00,   823.20,   110.90},
{ "Blackfield Chapel",            1325.60,   596.30,   -89.00,  1375.60,   795.00,   110.90},
{ "Blackfield Intersection",      1197.30,  1044.60,   -89.00,  1277.00,  1163.30,   110.90},
{ "Blackfield Intersection",      1166.50,   795.00,   -89.00,  1375.60,  1044.60,   110.90},
{ "Blackfield Intersection",      1277.00,  1044.60,   -89.00,  1315.30,  1087.60,   110.90},
{ "Blackfield Intersection",      1375.60,   823.20,   -89.00,  1457.30,   919.40,   110.90},
{ "Blueberry",                     104.50,  -220.10,     2.30,   349.60,   152.20,   200.00},
{ "Blueberry",                      19.60,  -404.10,     3.80,   349.60,  -220.10,   200.00},
{ "Blueberry Acres",              -319.60,  -220.10,     0.00,   104.50,   293.30,   200.00},
{ "Caligula's Palace",            2087.30,  1543.20,   -89.00,  2437.30,  1703.20,   110.90},
{ "Caligula's Palace",            2137.40,  1703.20,   -89.00,  2437.30,  1783.20,   110.90},
{ "Calton Heights",              -2274.10,   744.10,    -6.10, -1982.30,  1358.90,   200.00},
{ "Chinatown",                   -2274.10,   578.30,    -7.60, -2078.60,   744.10,   200.00},
{ "City Hall",                   -2867.80,   277.40,    -9.10, -2593.40,   458.40,   200.00},
{ "Come-A-Lot",                   2087.30,   943.20,   -89.00,  2623.10,  1203.20,   110.90},
{ "Commerce",                     1323.90, -1842.20,   -89.00,  1701.90, -1722.20,   110.90},
{ "Commerce",                     1323.90, -1722.20,   -89.00,  1440.90, -1577.50,   110.90},
{ "Commerce",                     1370.80, -1577.50,   -89.00,  1463.90, -1384.90,   110.90},
{ "Commerce",                     1463.90, -1577.50,   -89.00,  1667.90, -1430.80,   110.90},
{ "Commerce",                     1583.50, -1722.20,   -89.00,  1758.90, -1577.50,   110.90},
{ "Commerce",                     1667.90, -1577.50,   -89.00,  1812.60, -1430.80,   110.90},
{ "Conference Center",            1046.10, -1804.20,   -89.00,  1323.90, -1722.20,   110.90},
{ "Conference Center",            1073.20, -1842.20,   -89.00,  1323.90, -1804.20,   110.90},
{ "Cranberry Station",           -2007.80,    56.30,     0.00, -1922.00,   224.70,   100.00},
{ "Creek",                        2749.90,  1937.20,   -89.00,  2921.60,  2669.70,   110.90},
{ "Dillimore",                     580.70,  -674.80,    -9.50,   861.00,  -404.70,   200.00},
{ "Doherty",                     -2270.00,  -324.10,    -0.00, -1794.90,  -222.50,   200.00},
{ "Doherty",                     -2173.00,  -222.50,    -0.00, -1794.90,   265.20,   200.00},
{ "Downtown",                    -1982.30,   744.10,    -6.10, -1871.70,  1274.20,   200.00},
{ "Downtown",                    -1871.70,  1176.40,    -4.50, -1620.30,  1274.20,   200.00},
{ "Downtown",                    -1700.00,   744.20,    -6.10, -1580.00,  1176.50,   200.00},
{ "Downtown",                    -1580.00,   744.20,    -6.10, -1499.80,  1025.90,   200.00},
{ "Downtown",                    -2078.60,   578.30,    -7.60, -1499.80,   744.20,   200.00},
{ "Downtown",                    -1993.20,   265.20,    -9.10, -1794.90,   578.30,   200.00},
{ "Downtown",                     1463.90, -1430.80,   -89.00,  1724.70, -1290.80,   110.90},
{ "Downtown",                     1724.70, -1430.80,   -89.00,  1812.60, -1250.90,   110.90},
{ "Downtown",                     1463.90, -1290.80,   -89.00,  1724.70, -1150.80,   110.90},
{ "Downtown",                     1370.80, -1384.90,   -89.00,  1463.90, -1170.80,   110.90},
{ "Downtown",                     1724.70, -1250.90,   -89.00,  1812.60, -1150.80,   110.90},
{ "Downtown",                     1370.80, -1170.80,   -89.00,  1463.90, -1130.80,   110.90},
{ "Downtown",                     1378.30, -1130.80,   -89.00,  1463.90, -1026.30,   110.90},
{ "Downtown",                     1391.00, -1026.30,   -89.00,  1463.90,  -926.90,   110.90},
{ "Downtown",                     1507.50, -1385.20,   110.90,  1582.50, -1325.30,   335.90},
{ "East Beach",                   2632.80, -1852.80,   -89.00,  2959.30, -1668.10,   110.90},
{ "East Beach",                   2632.80, -1668.10,   -89.00,  2747.70, -1393.40,   110.90},
{ "East Beach",                   2747.70, -1668.10,   -89.00,  2959.30, -1498.60,   110.90},
{ "East Beach",                   2747.70, -1498.60,   -89.00,  2959.30, -1120.00,   110.90},
{ "East Los Santos",              2421.00, -1628.50,   -89.00,  2632.80, -1454.30,   110.90},
{ "East Los Santos",              2222.50, -1628.50,   -89.00,  2421.00, -1494.00,   110.90},
{ "East Los Santos",              2266.20, -1494.00,   -89.00,  2381.60, -1372.00,   110.90},
{ "East Los Santos",              2381.60, -1494.00,   -89.00,  2421.00, -1454.30,   110.90},
{ "East Los Santos",              2281.40, -1372.00,   -89.00,  2381.60, -1135.00,   110.90},
{ "East Los Santos",              2381.60, -1454.30,   -89.00,  2462.10, -1135.00,   110.90},
{ "East Los Santos",              2462.10, -1454.30,   -89.00,  2581.70, -1135.00,   110.90},
{ "Easter Basin",                -1794.90,   249.90,    -9.10, -1242.90,   578.30,   200.00},
{ "Easter Basin",                -1794.90,   -50.00,    -0.00, -1499.80,   249.90,   200.00},
{ "Easter Bay Airport",          -1499.80,   -50.00,    -0.00, -1242.90,   249.90,   200.00},
{ "Easter Bay Airport",          -1794.90,  -730.10,    -3.00, -1213.90,   -50.00,   200.00},
{ "Easter Bay Airport",          -1213.90,  -730.10,     0.00, -1132.80,   -50.00,   200.00},
{ "Easter Bay Airport",          -1242.90,   -50.00,     0.00, -1213.90,   578.30,   200.00},
{ "Easter Bay Airport",          -1213.90,   -50.00,    -4.50,  -947.90,   578.30,   200.00},
{ "Easter Bay Airport",          -1315.40,  -405.30,    15.40, -1264.40,  -209.50,    25.40},
{ "Easter Bay Airport",          -1354.30,  -287.30,    15.40, -1315.40,  -209.50,    25.40},
{ "Easter Bay Airport",          -1490.30,  -209.50,    15.40, -1264.40,  -148.30,    25.40},
{ "Easter Bay Chemicals",        -1132.80,  -768.00,     0.00,  -956.40,  -578.10,   200.00},
{ "Easter Bay Chemicals",        -1132.80,  -787.30,     0.00,  -956.40,  -768.00,   200.00},
{ "El Castillo del Diablo",       -464.50,  2217.60,     0.00,  -208.50,  2580.30,   200.00},
{ "El Castillo del Diablo",       -208.50,  2123.00,    -7.60,   114.00,  2337.10,   200.00},
{ "El Castillo del Diablo",       -208.50,  2337.10,     0.00,     8.40,  2487.10,   200.00},
{ "El Corona",                    1812.60, -2179.20,   -89.00,  1970.60, -1852.80,   110.90},
{ "El Corona",                    1692.60, -2179.20,   -89.00,  1812.60, -1842.20,   110.90},
{ "El Quebrados",                -1645.20,  2498.50,     0.00, -1372.10,  2777.80,   200.00},
{ "Esplanade East",              -1620.30,  1176.50,    -4.50, -1580.00,  1274.20,   200.00},
{ "Esplanade East",              -1580.00,  1025.90,    -6.10, -1499.80,  1274.20,   200.00},
{ "Esplanade East",              -1499.80,   578.30,   -79.60, -1339.80,  1274.20,    20.30},
{ "Esplanade North",             -2533.00,  1358.90,    -4.50, -1996.60,  1501.20,   200.00},
{ "Esplanade North",             -1996.60,  1358.90,    -4.50, -1524.20,  1592.50,   200.00},
{ "Esplanade North",             -1982.30,  1274.20,    -4.50, -1524.20,  1358.90,   200.00},
{ "Fallen Tree",                  -792.20,  -698.50,    -5.30,  -452.40,  -380.00,   200.00},
{ "Fallow Bridge",                 434.30,   366.50,     0.00,   603.00,   555.60,   200.00},
{ "Fern Ridge",                    508.10,  -139.20,     0.00,  1306.60,   119.50,   200.00},
{ "Financial",                   -1871.70,   744.10,    -6.10, -1701.30,  1176.40,   300.00},
{ "Fisher's Lagoon",              1916.90,  -233.30,  -100.00,  2131.70,    13.80,   200.00},
{ "Flint Intersection",           -187.70, -1596.70,   -89.00,    17.00, -1276.60,   110.90},
{ "Flint Range",                  -594.10, -1648.50,     0.00,  -187.70, -1276.60,   200.00},
{ "Fort Carson",                  -376.20,   826.30,    -3.00,   123.70,  1220.40,   200.00},
{ "Foster Valley",               -2270.00,  -430.20,    -0.00, -2178.60,  -324.10,   200.00},
{ "Foster Valley",               -2178.60,  -599.80,    -0.00, -1794.90,  -324.10,   200.00},
{ "Foster Valley",               -2178.60, -1115.50,     0.00, -1794.90,  -599.80,   200.00},
{ "Foster Valley",               -2178.60, -1250.90,     0.00, -1794.90, -1115.50,   200.00},
{ "Frederick Bridge",             2759.20,   296.50,     0.00,  2774.20,   594.70,   200.00},
{ "Gant Bridge",                 -2741.40,  1659.60,    -6.10, -2616.40,  2175.10,   200.00},
{ "Gant Bridge",                 -2741.00,  1490.40,    -6.10, -2616.40,  1659.60,   200.00},
{ "Ganton",                       2222.50, -1852.80,   -89.00,  2632.80, -1722.30,   110.90},
{ "Ganton",                       2222.50, -1722.30,   -89.00,  2632.80, -1628.50,   110.90},
{ "Garcia",                      -2411.20,  -222.50,    -0.00, -2173.00,   265.20,   200.00},
{ "Garcia",                      -2395.10,  -222.50,    -5.30, -2354.00,  -204.70,   200.00},
{ "Garver Bridge",               -1339.80,   828.10,   -89.00, -1213.90,  1057.00,   110.90},
{ "Garver Bridge",               -1213.90,   950.00,   -89.00, -1087.90,  1178.90,   110.90},
{ "Garver Bridge",               -1499.80,   696.40,  -179.60, -1339.80,   925.30,    20.30},
{ "Glen Park",                    1812.60, -1449.60,   -89.00,  1996.90, -1350.70,   110.90},
{ "Glen Park",                    1812.60, -1100.80,   -89.00,  1994.30,  -973.30,   110.90},
{ "Glen Park",                    1812.60, -1350.70,   -89.00,  2056.80, -1100.80,   110.90},
{ "Green Palms",                   176.50,  1305.40,    -3.00,   338.60,  1520.70,   200.00},
{ "Greenglass College",            964.30,  1044.60,   -89.00,  1197.30,  1203.20,   110.90},
{ "Greenglass College",            964.30,   930.80,   -89.00,  1166.50,  1044.60,   110.90},
{ "Hampton Barns",                 603.00,   264.30,     0.00,   761.90,   366.50,   200.00},
{ "Hankypanky Point",             2576.90,    62.10,     0.00,  2759.20,   385.50,   200.00},
{ "Harry Gold Parkway",           1777.30,   863.20,   -89.00,  1817.30,  2342.80,   110.90},
{ "Hashbury",                    -2593.40,  -222.50,    -0.00, -2411.20,    54.70,   200.00},
{ "Hilltop Farm",                  967.30,  -450.30,    -3.00,  1176.70,  -217.90,   200.00},
{ "Hunter Quarry",                 337.20,   710.80,  -115.20,   860.50,  1031.70,   203.70},
{ "Idlewood",                     1812.60, -1852.80,   -89.00,  1971.60, -1742.30,   110.90},
{ "Idlewood",                     1812.60, -1742.30,   -89.00,  1951.60, -1602.30,   110.90},
{ "Idlewood",                     1951.60, -1742.30,   -89.00,  2124.60, -1602.30,   110.90},
{ "Idlewood",                     1812.60, -1602.30,   -89.00,  2124.60, -1449.60,   110.90},
{ "Idlewood",                     2124.60, -1742.30,   -89.00,  2222.50, -1494.00,   110.90},
{ "Idlewood",                     1971.60, -1852.80,   -89.00,  2222.50, -1742.30,   110.90},
{ "Jefferson",                    1996.90, -1449.60,   -89.00,  2056.80, -1350.70,   110.90},
{ "Jefferson",                    2124.60, -1494.00,   -89.00,  2266.20, -1449.60,   110.90},
{ "Jefferson",                    2056.80, -1372.00,   -89.00,  2281.40, -1210.70,   110.90},
{ "Jefferson",                    2056.80, -1210.70,   -89.00,  2185.30, -1126.30,   110.90},
{ "Jefferson",                    2185.30, -1210.70,   -89.00,  2281.40, -1154.50,   110.90},
{ "Jefferson",                    2056.80, -1449.60,   -89.00,  2266.20, -1372.00,   110.90},
{ "Julius Thruway East",          2623.10,   943.20,   -89.00,  2749.90,  1055.90,   110.90},
{ "Julius Thruway East",          2685.10,  1055.90,   -89.00,  2749.90,  2626.50,   110.90},
{ "Julius Thruway East",          2536.40,  2442.50,   -89.00,  2685.10,  2542.50,   110.90},
{ "Julius Thruway East",          2625.10,  2202.70,   -89.00,  2685.10,  2442.50,   110.90},
{ "Julius Thruway North",         2498.20,  2542.50,   -89.00,  2685.10,  2626.50,   110.90},
{ "Julius Thruway North",         2237.40,  2542.50,   -89.00,  2498.20,  2663.10,   110.90},
{ "Julius Thruway North",         2121.40,  2508.20,   -89.00,  2237.40,  2663.10,   110.90},
{ "Julius Thruway North",         1938.80,  2508.20,   -89.00,  2121.40,  2624.20,   110.90},
{ "Julius Thruway North",         1534.50,  2433.20,   -89.00,  1848.40,  2583.20,   110.90},
{ "Julius Thruway North",         1848.40,  2478.40,   -89.00,  1938.80,  2553.40,   110.90},
{ "Julius Thruway North",         1704.50,  2342.80,   -89.00,  1848.40,  2433.20,   110.90},
{ "Julius Thruway North",         1377.30,  2433.20,   -89.00,  1534.50,  2507.20,   110.90},
{ "Julius Thruway South",         1457.30,   823.20,   -89.00,  2377.30,   863.20,   110.90},
{ "Julius Thruway South",         2377.30,   788.80,   -89.00,  2537.30,   897.90,   110.90},
{ "Julius Thruway West",          1197.30,  1163.30,   -89.00,  1236.60,  2243.20,   110.90},
{ "Julius Thruway West",          1236.60,  2142.80,   -89.00,  1297.40,  2243.20,   110.90},
{ "Juniper Hill",                -2533.00,   578.30,    -7.60, -2274.10,   968.30,   200.00},
{ "Juniper Hollow",              -2533.00,   968.30,    -6.10, -2274.10,  1358.90,   200.00},
{ "K.A.C.C. Military Fuels",      2498.20,  2626.50,   -89.00,  2749.90,  2861.50,   110.90},
{ "Kincaid Bridge",              -1339.80,   599.20,   -89.00, -1213.90,   828.10,   110.90},
{ "Kincaid Bridge",              -1213.90,   721.10,   -89.00, -1087.90,   950.00,   110.90},
{ "Kincaid Bridge",              -1087.90,   855.30,   -89.00,  -961.90,   986.20,   110.90},
{ "King's",                      -2329.30,   458.40,    -7.60, -1993.20,   578.30,   200.00},
{ "King's",                      -2411.20,   265.20,    -9.10, -1993.20,   373.50,   200.00},
{ "King's",                      -2253.50,   373.50,    -9.10, -1993.20,   458.40,   200.00},
{ "LVA Freight Depot",            1457.30,   863.20,   -89.00,  1777.40,  1143.20,   110.90},
{ "LVA Freight Depot",            1375.60,   919.40,   -89.00,  1457.30,  1203.20,   110.90},
{ "LVA Freight Depot",            1277.00,  1087.60,   -89.00,  1375.60,  1203.20,   110.90},
{ "LVA Freight Depot",            1315.30,  1044.60,   -89.00,  1375.60,  1087.60,   110.90},
{ "LVA Freight Depot",            1236.60,  1163.40,   -89.00,  1277.00,  1203.20,   110.90},
{ "Las Barrancas",                -926.10,  1398.70,    -3.00,  -719.20,  1634.60,   200.00},
{ "Las Brujas",                   -365.10,  2123.00,    -3.00,  -208.50,  2217.60,   200.00},
{ "Las Colinas",                  1994.30, -1100.80,   -89.00,  2056.80,  -920.80,   110.90},
{ "Las Colinas",                  2056.80, -1126.30,   -89.00,  2126.80,  -920.80,   110.90},
{ "Las Colinas",                  2185.30, -1154.50,   -89.00,  2281.40,  -934.40,   110.90},
{ "Las Colinas",                  2126.80, -1126.30,   -89.00,  2185.30,  -934.40,   110.90},
{ "Las Colinas",                  2747.70, -1120.00,   -89.00,  2959.30,  -945.00,   110.90},
{ "Las Colinas",                  2632.70, -1135.00,   -89.00,  2747.70,  -945.00,   110.90},
{ "Las Colinas",                  2281.40, -1135.00,   -89.00,  2632.70,  -945.00,   110.90},
{ "Las Payasadas",                -354.30,  2580.30,     2.00,  -133.60,  2816.80,   200.00},
{ "Las Venturas Airport",         1236.60,  1203.20,   -89.00,  1457.30,  1883.10,   110.90},
{ "Las Venturas Airport",         1457.30,  1203.20,   -89.00,  1777.30,  1883.10,   110.90},
{ "Las Venturas Airport",         1457.30,  1143.20,   -89.00,  1777.40,  1203.20,   110.90},
{ "Las Venturas Airport",         1515.80,  1586.40,   -12.50,  1729.90,  1714.50,    87.50},
{ "Last Dime Motel",              1823.00,   596.30,   -89.00,  1997.20,   823.20,   110.90},
{ "Leafy Hollow",                -1166.90, -1856.00,     0.00,  -815.60, -1602.00,   200.00},
{ "Lil' Probe Inn",                -90.20,  1286.80,    -3.00,   153.80,  1554.10,   200.00},
{ "Linden Side",                  2749.90,   943.20,   -89.00,  2923.30,  1198.90,   110.90},
{ "Linden Station",               2749.90,  1198.90,   -89.00,  2923.30,  1548.90,   110.90},
{ "Linden Station",               2811.20,  1229.50,   -39.50,  2861.20,  1407.50,    60.40},
{ "Little Mexico",                1701.90, -1842.20,   -89.00,  1812.60, -1722.20,   110.90},
{ "Little Mexico",                1758.90, -1722.20,   -89.00,  1812.60, -1577.50,   110.90},
{ "Los Flores",                   2581.70, -1454.30,   -89.00,  2632.80, -1393.40,   110.90},
{ "Los Flores",                   2581.70, -1393.40,   -89.00,  2747.70, -1135.00,   110.90},
{ "Los Santos International",     1249.60, -2394.30,   -89.00,  1852.00, -2179.20,   110.90},
{ "Los Santos International",     1852.00, -2394.30,   -89.00,  2089.00, -2179.20,   110.90},
{ "Los Santos International",     1382.70, -2730.80,   -89.00,  2201.80, -2394.30,   110.90},
{ "Los Santos International",     1974.60, -2394.30,   -39.00,  2089.00, -2256.50,    60.90},
{ "Los Santos International",     1400.90, -2669.20,   -39.00,  2189.80, -2597.20,    60.90},
{ "Los Santos International",     2051.60, -2597.20,   -39.00,  2152.40, -2394.30,    60.90},
{ "Marina",                        647.70, -1804.20,   -89.00,   851.40, -1577.50,   110.90},
{ "Marina",                        647.70, -1577.50,   -89.00,   807.90, -1416.20,   110.90},
{ "Marina",                        807.90, -1577.50,   -89.00,   926.90, -1416.20,   110.90},
{ "Market",                        787.40, -1416.20,   -89.00,  1072.60, -1310.20,   110.90},
{ "Market",                        952.60, -1310.20,   -89.00,  1072.60, -1130.80,   110.90},
{ "Market",                       1072.60, -1416.20,   -89.00,  1370.80, -1130.80,   110.90},
{ "Market",                        926.90, -1577.50,   -89.00,  1370.80, -1416.20,   110.90},
{ "Market Station",                787.40, -1410.90,   -34.10,   866.00, -1310.20,    65.80},
{ "Martin Bridge",                -222.10,   293.30,     0.00,  -122.10,   476.40,   200.00},
{ "Missionary Hill",             -2994.40,  -811.20,     0.00, -2178.60,  -430.20,   200.00},
{ "Montgomery",                   1119.50,   119.50,    -3.00,  1451.40,   493.30,   200.00},
{ "Montgomery",                   1451.40,   347.40,    -6.10,  1582.40,   420.80,   200.00},
{ "Montgomery Intersection",      1546.60,   208.10,     0.00,  1745.80,   347.40,   200.00},
{ "Montgomery Intersection",      1582.40,   347.40,     0.00,  1664.60,   401.70,   200.00},
{ "Mulholland",                   1414.00,  -768.00,   -89.00,  1667.60,  -452.40,   110.90},
{ "Mulholland",                   1281.10,  -452.40,   -89.00,  1641.10,  -290.90,   110.90},
{ "Mulholland",                   1269.10,  -768.00,   -89.00,  1414.00,  -452.40,   110.90},
{ "Mulholland",                   1357.00,  -926.90,   -89.00,  1463.90,  -768.00,   110.90},
{ "Mulholland",                   1318.10,  -910.10,   -89.00,  1357.00,  -768.00,   110.90},
{ "Mulholland",                   1169.10,  -910.10,   -89.00,  1318.10,  -768.00,   110.90},
{ "Mulholland",                    768.60,  -954.60,   -89.00,   952.60,  -860.60,   110.90},
{ "Mulholland",                    687.80,  -860.60,   -89.00,   911.80,  -768.00,   110.90},
{ "Mulholland",                    737.50,  -768.00,   -89.00,  1142.20,  -674.80,   110.90},
{ "Mulholland",                   1096.40,  -910.10,   -89.00,  1169.10,  -768.00,   110.90},
{ "Mulholland",                    952.60,  -937.10,   -89.00,  1096.40,  -860.60,   110.90},
{ "Mulholland",                    911.80,  -860.60,   -89.00,  1096.40,  -768.00,   110.90},
{ "Mulholland",                    861.00,  -674.80,   -89.00,  1156.50,  -600.80,   110.90},
{ "Mulholland Intersection",      1463.90, -1150.80,   -89.00,  1812.60,  -768.00,   110.90},
{ "North Rock",                   2285.30,  -768.00,     0.00,  2770.50,  -269.70,   200.00},
{ "Ocean Docks",                  2373.70, -2697.00,   -89.00,  2809.20, -2330.40,   110.90},
{ "Ocean Docks",                  2201.80, -2418.30,   -89.00,  2324.00, -2095.00,   110.90},
{ "Ocean Docks",                  2324.00, -2302.30,   -89.00,  2703.50, -2145.10,   110.90},
{ "Ocean Docks",                  2089.00, -2394.30,   -89.00,  2201.80, -2235.80,   110.90},
{ "Ocean Docks",                  2201.80, -2730.80,   -89.00,  2324.00, -2418.30,   110.90},
{ "Ocean Docks",                  2703.50, -2302.30,   -89.00,  2959.30, -2126.90,   110.90},
{ "Ocean Docks",                  2324.00, -2145.10,   -89.00,  2703.50, -2059.20,   110.90},
{ "Ocean Flats",                 -2994.40,   277.40,    -9.10, -2867.80,   458.40,   200.00},
{ "Ocean Flats",                 -2994.40,  -222.50,    -0.00, -2593.40,   277.40,   200.00},
{ "Ocean Flats",                 -2994.40,  -430.20,    -0.00, -2831.80,  -222.50,   200.00},
{ "Octane Springs",                338.60,  1228.50,     0.00,   664.30,  1655.00,   200.00},
{ "Old Venturas Strip",           2162.30,  2012.10,   -89.00,  2685.10,  2202.70,   110.90},
{ "Palisades",                   -2994.40,   458.40,    -6.10, -2741.00,  1339.60,   200.00},
{ "Palomino Creek",               2160.20,  -149.00,     0.00,  2576.90,   228.30,   200.00},
{ "Paradiso",                    -2741.00,   793.40,    -6.10, -2533.00,  1268.40,   200.00},
{ "Pershing Square",              1440.90, -1722.20,   -89.00,  1583.50, -1577.50,   110.90},
{ "Pilgrim",                      2437.30,  1383.20,   -89.00,  2624.40,  1783.20,   110.90},
{ "Pilgrim",                      2624.40,  1383.20,   -89.00,  2685.10,  1783.20,   110.90},
{ "Pilson Intersection",          1098.30,  2243.20,   -89.00,  1377.30,  2507.20,   110.90},
{ "Pirates in Men's Pants",       1817.30,  1469.20,   -89.00,  2027.40,  1703.20,   110.90},
{ "Playa del Seville",            2703.50, -2126.90,   -89.00,  2959.30, -1852.80,   110.90},
{ "Prickle Pine",                 1534.50,  2583.20,   -89.00,  1848.40,  2863.20,   110.90},
{ "Prickle Pine",                 1117.40,  2507.20,   -89.00,  1534.50,  2723.20,   110.90},
{ "Prickle Pine",                 1848.40,  2553.40,   -89.00,  1938.80,  2863.20,   110.90},
{ "Prickle Pine",                 1938.80,  2624.20,   -89.00,  2121.40,  2861.50,   110.90},
{ "Queens",                      -2533.00,   458.40,     0.00, -2329.30,   578.30,   200.00},
{ "Queens",                      -2593.40,    54.70,     0.00, -2411.20,   458.40,   200.00},
{ "Queens",                      -2411.20,   373.50,     0.00, -2253.50,   458.40,   200.00},
{ "Randolph Industrial Estate",   1558.00,   596.30,   -89.00,  1823.00,   823.20,   110.90},
{ "Redsands East",                1817.30,  2011.80,   -89.00,  2106.70,  2202.70,   110.90},
{ "Redsands East",                1817.30,  2202.70,   -89.00,  2011.90,  2342.80,   110.90},
{ "Redsands East",                1848.40,  2342.80,   -89.00,  2011.90,  2478.40,   110.90},
{ "Redsands West",                1236.60,  1883.10,   -89.00,  1777.30,  2142.80,   110.90},
{ "Redsands West",                1297.40,  2142.80,   -89.00,  1777.30,  2243.20,   110.90},
{ "Redsands West",                1377.30,  2243.20,   -89.00,  1704.50,  2433.20,   110.90},
{ "Redsands West",                1704.50,  2243.20,   -89.00,  1777.30,  2342.80,   110.90},
{ "Regular Tom",                  -405.70,  1712.80,    -3.00,  -276.70,  1892.70,   200.00},
{ "Richman",                       647.50, -1118.20,   -89.00,   787.40,  -954.60,   110.90},
{ "Richman",                       647.50,  -954.60,   -89.00,   768.60,  -860.60,   110.90},
{ "Richman",                       225.10, -1369.60,   -89.00,   334.50, -1292.00,   110.90},
{ "Richman",                       225.10, -1292.00,   -89.00,   466.20, -1235.00,   110.90},
{ "Richman",                        72.60, -1404.90,   -89.00,   225.10, -1235.00,   110.90},
{ "Richman",                        72.60, -1235.00,   -89.00,   321.30, -1008.10,   110.90},
{ "Richman",                       321.30, -1235.00,   -89.00,   647.50, -1044.00,   110.90},
{ "Richman",                       321.30, -1044.00,   -89.00,   647.50,  -860.60,   110.90},
{ "Richman",                       321.30,  -860.60,   -89.00,   687.80,  -768.00,   110.90},
{ "Richman",                       321.30,  -768.00,   -89.00,   700.70,  -674.80,   110.90},
{ "Robada Intersection",         -1119.00,  1178.90,   -89.00,  -862.00,  1351.40,   110.90},
{ "Roca Escalante",               2237.40,  2202.70,   -89.00,  2536.40,  2542.50,   110.90},
{ "Roca Escalante",               2536.40,  2202.70,   -89.00,  2625.10,  2442.50,   110.90},
{ "Rockshore East",               2537.30,   676.50,   -89.00,  2902.30,   943.20,   110.90},
{ "Rockshore West",               1997.20,   596.30,   -89.00,  2377.30,   823.20,   110.90},
{ "Rockshore West",               2377.30,   596.30,   -89.00,  2537.30,   788.80,   110.90},
{ "Rodeo",                          72.60, -1684.60,   -89.00,   225.10, -1544.10,   110.90},
{ "Rodeo",                          72.60, -1544.10,   -89.00,   225.10, -1404.90,   110.90},
{ "Rodeo",                         225.10, -1684.60,   -89.00,   312.80, -1501.90,   110.90},
{ "Rodeo",                         225.10, -1501.90,   -89.00,   334.50, -1369.60,   110.90},
{ "Rodeo",                         334.50, -1501.90,   -89.00,   422.60, -1406.00,   110.90},
{ "Rodeo",                         312.80, -1684.60,   -89.00,   422.60, -1501.90,   110.90},
{ "Rodeo",                         422.60, -1684.60,   -89.00,   558.00, -1570.20,   110.90},
{ "Rodeo",                         558.00, -1684.60,   -89.00,   647.50, -1384.90,   110.90},
{ "Rodeo",                         466.20, -1570.20,   -89.00,   558.00, -1385.00,   110.90},
{ "Rodeo",                         422.60, -1570.20,   -89.00,   466.20, -1406.00,   110.90},
{ "Rodeo",                         466.20, -1385.00,   -89.00,   647.50, -1235.00,   110.90},
{ "Rodeo",                         334.50, -1406.00,   -89.00,   466.20, -1292.00,   110.90},
{ "Royal Casino",                 2087.30,  1383.20,   -89.00,  2437.30,  1543.20,   110.90},
{ "San Andreas Sound",            2450.30,   385.50,  -100.00,  2759.20,   562.30,   200.00},
{ "Santa Flora",                 -2741.00,   458.40,    -7.60, -2533.00,   793.40,   200.00},
{ "Santa Maria Beach",             342.60, -2173.20,   -89.00,   647.70, -1684.60,   110.90},
{ "Santa Maria Beach",              72.60, -2173.20,   -89.00,   342.60, -1684.60,   110.90},
{ "Shady Cabin",                 -1632.80, -2263.40,    -3.00, -1601.30, -2231.70,   200.00},
{ "Shady Creeks",                -1820.60, -2643.60,    -8.00, -1226.70, -1771.60,   200.00},
{ "Shady Creeks",                -2030.10, -2174.80,    -6.10, -1820.60, -1771.60,   200.00},
{ "Sobell Rail Yards",            2749.90,  1548.90,   -89.00,  2923.30,  1937.20,   110.90},
{ "Spinybed",                     2121.40,  2663.10,   -89.00,  2498.20,  2861.50,   110.90},
{ "Starfish Casino",              2437.30,  1783.20,   -89.00,  2685.10,  2012.10,   110.90},
{ "Starfish Casino",              2437.30,  1858.10,   -39.00,  2495.00,  1970.80,    60.90},
{ "Starfish Casino",              2162.30,  1883.20,   -89.00,  2437.30,  2012.10,   110.90},
{ "Temple",                       1252.30, -1130.80,   -89.00,  1378.30, -1026.30,   110.90},
{ "Temple",                       1252.30, -1026.30,   -89.00,  1391.00,  -926.90,   110.90},
{ "Temple",                       1252.30,  -926.90,   -89.00,  1357.00,  -910.10,   110.90},
{ "Temple",                        952.60, -1130.80,   -89.00,  1096.40,  -937.10,   110.90},
{ "Temple",                       1096.40, -1130.80,   -89.00,  1252.30, -1026.30,   110.90},
{ "Temple",                       1096.40, -1026.30,   -89.00,  1252.30,  -910.10,   110.90},
{ "The Camel's Toe",              2087.30,  1203.20,   -89.00,  2640.40,  1383.20,   110.90},
{ "The Clown's Pocket",           2162.30,  1783.20,   -89.00,  2437.30,  1883.20,   110.90},
{ "The Emerald Isle",             2011.90,  2202.70,   -89.00,  2237.40,  2508.20,   110.90},
{ "The Farm",                    -1209.60, -1317.10,   114.90,  -908.10,  -787.30,   251.90},
{ "The Four Dragons Casino",      1817.30,   863.20,   -89.00,  2027.30,  1083.20,   110.90},
{ "The High Roller",              1817.30,  1283.20,   -89.00,  2027.30,  1469.20,   110.90},
{ "The Mako Span",                1664.60,   401.70,     0.00,  1785.10,   567.20,   200.00},
{ "The Panopticon",               -947.90,  -304.30,    -1.10,  -319.60,   327.00,   200.00},
{ "The Pink Swan",                1817.30,  1083.20,   -89.00,  2027.30,  1283.20,   110.90},
{ "The Sherman Dam",              -968.70,  1929.40,    -3.00,  -481.10,  2155.20,   200.00},
{ "The Strip",                    2027.40,   863.20,   -89.00,  2087.30,  1703.20,   110.90},
{ "The Strip",                    2106.70,  1863.20,   -89.00,  2162.30,  2202.70,   110.90},
{ "The Strip",                    2027.40,  1783.20,   -89.00,  2162.30,  1863.20,   110.90},
{ "The Strip",                    2027.40,  1703.20,   -89.00,  2137.40,  1783.20,   110.90},
{ "The Visage",                   1817.30,  1863.20,   -89.00,  2106.70,  2011.80,   110.90},
{ "The Visage",                   1817.30,  1703.20,   -89.00,  2027.40,  1863.20,   110.90},
{ "Unity Station",                1692.60, -1971.80,   -20.40,  1812.60, -1932.80,    79.50},
{ "Valle Ocultado",               -936.60,  2611.40,     2.00,  -715.90,  2847.90,   200.00},
{ "Verdant Bluffs",                930.20, -2488.40,   -89.00,  1249.60, -2006.70,   110.90},
{ "Verdant Bluffs",               1073.20, -2006.70,   -89.00,  1249.60, -1842.20,   110.90},
{ "Verdant Bluffs",               1249.60, -2179.20,   -89.00,  1692.60, -1842.20,   110.90},
{ "Verdant Meadows",                37.00,  2337.10,    -3.00,   435.90,  2677.90,   200.00},
{ "Verona Beach",                  647.70, -2173.20,   -89.00,   930.20, -1804.20,   110.90},
{ "Verona Beach",                  930.20, -2006.70,   -89.00,  1073.20, -1804.20,   110.90},
{ "Verona Beach",                  851.40, -1804.20,   -89.00,  1046.10, -1577.50,   110.90},
{ "Verona Beach",                 1161.50, -1722.20,   -89.00,  1323.90, -1577.50,   110.90},
{ "Verona Beach",                 1046.10, -1722.20,   -89.00,  1161.50, -1577.50,   110.90},
{ "Vinewood",                      787.40, -1310.20,   -89.00,   952.60, -1130.80,   110.90},
{ "Vinewood",                      787.40, -1130.80,   -89.00,   952.60,  -954.60,   110.90},
{ "Vinewood",                      647.50, -1227.20,   -89.00,   787.40, -1118.20,   110.90},
{ "Vinewood",                      647.70, -1416.20,   -89.00,   787.40, -1227.20,   110.90},
{ "Whitewood Estates",             883.30,  1726.20,   -89.00,  1098.30,  2507.20,   110.90},
{ "Whitewood Estates",            1098.30,  1726.20,   -89.00,  1197.30,  2243.20,   110.90},
{ "Willowfield",                  1970.60, -2179.20,   -89.00,  2089.00, -1852.80,   110.90},
{ "Willowfield",                  2089.00, -2235.80,   -89.00,  2201.80, -1989.90,   110.90},
{ "Willowfield",                  2089.00, -1989.90,   -89.00,  2324.00, -1852.80,   110.90},
{ "Willowfield",                  2201.80, -2095.00,   -89.00,  2324.00, -1989.90,   110.90},
{ "Willowfield",                  2541.70, -1941.40,   -89.00,  2703.50, -1852.80,   110.90},
{ "Willowfield",                  2324.00, -2059.20,   -89.00,  2541.70, -1852.80,   110.90},
{ "Willowfield",                  2541.70, -2059.20,   -89.00,  2703.50, -1941.40,   110.90},
{ "Yellow Bell Station",          1377.40,  2600.40,   -21.90,  1492.40,  2687.30,    78.00}
};

new Float:Zones1[][GPSInfo] = {
{ "Los Santos",                     44.60, -2892.90,  -242.90,  2997.00,  -768.00,   900.00},
{ "Las Venturas",                  869.40,   596.30,  -242.90,  2997.00,  2993.80,   900.00},
{ "Bone County",                  -480.50,   596.30,  -242.90,   869.40,  2993.80,   900.00},
{ "Tierra Robada",               -2997.40,  1659.60,  -242.90,  -480.50,  2993.80,   900.00},
{ "Tierra Robada",               -1213.90,   596.30,  -242.90,  -480.50,  1659.60,   900.00},
{ "San Fierro",                  -2997.40, -1115.50,  -242.90, -1213.90,  1659.60,   900.00},
{ "Red County",                  -1213.90,  -768.00,  -242.90,  2997.00,   596.30,   900.00},
{ "Flint County",                -1213.90, -2892.90,  -242.90,    44.60,  -768.00,   900.00},
{ "Whetstone",                   -2997.40, -2892.90,  -242.90, -1213.90, -1115.50,   900.00}
};


main()
{
print("\n-------------------------------------------------------------");
print("GameMode MdP carregado com sucesso!");
print("-------------------------------------------------------------\n");
}

public OnPlayerRequestSpawn(playerid)
{
PlayAudioStreamForPlayer(playerid, "http://streaming.shoutcast.com/RadioHunter-TheHitzChannel");
NickEsconder[playerid]=0;
arenacacadaEsconder[playerid] = 0;
X1sArena[playerid] = false;

/*//textdraw em cima do mapa
Textdraw8= TextDrawCreate(32.000000, 315.000000, "~r~~h~~h~Mundo dos Pikas");
TextDrawBackgroundColor(Textdraw8, 255);
TextDrawFont(Textdraw8, 0);
TextDrawLetterSize(Textdraw8, 0.459999, 2.599998);
TextDrawSetOutline(Textdraw8, 2);
TextDrawSetProportional(Textdraw8, 1);
TextDrawSetShadow(Textdraw8, 1);
GameTextForPlayer(playerid, " ", 100, 5);*/
TextDrawHideForPlayer(playerid, ImagemEntrada);
TextDrawHideForPlayer(playerid, texto9);
SetupPlayerForClassSelection(playerid);
TextDrawHideForPlayer(playerid, Textdraw25);
TextDrawHideForPlayer(playerid, Textdraw26);
TextDrawHideForPlayer(playerid, Textdraw27);
TextDrawHideForPlayer(playerid, Textdraw28);
TextDrawHideForPlayer(playerid, Textdraw29);
TextDrawHideForPlayer(playerid, Textdraw30);

//=============== Sistema de bom dia, boa tarde e boa noite=====================
	new Hour, Min, Sec;
	new string[56];
	new pname[MAX_PLAYER_NAME];
	gettime(Hour,Min,Sec);
	GetPlayerName(playerid,pname,sizeof(pname));

	switch(Hour)	{
		case 0..5:		{
		format(string, sizeof(string), "~r~~h~~h~Boa Madrugada ~n~~w~%s",pname);
		GameTextForPlayer(playerid, string, 4000, 3);
		}
		case 6..11:		{
		format(string, sizeof(string), "~r~~h~~h~~Bom Dia ~n~~w~%s",pname);
		GameTextForPlayer(playerid, string, 4000, 3);
		}
		case 12..18:		{
		format(string, sizeof(string), "~r~~h~~h~Boa Tarde ~n~~w~%s",pname);
		GameTextForPlayer(playerid, string, 4000, 3);
		}
		case 19..23:		{
		format(string, sizeof(string), "~r~~h~~h~Boa Noite ~n~~w~%s",pname);
		GameTextForPlayer(playerid, string, 4000, 3);
		}
	}
return 1;
}

forward OnPlayerLogin(playerid);
public OnPlayerLogin(playerid){
	GodCarOn[playerid] = CallRemoteFunction("GetLastGCStatus", "i", playerid);
	AutoTrancar[playerid] = CallRemoteFunction("GetLastTrancarStatus", "i", playerid);
	skin[playerid] = CallRemoteFunction("GetPlayerLastSkin","i",playerid);
	cor[playerid] = CallRemoteFunction("GetPlayerLastColor","i",playerid);
	Spree[playerid] = CallRemoteFunction("GetLastSpreeStatus","i",playerid);
	Rojoes[playerid] = CallRemoteFunction("GetLastRojoesStatus","i",playerid);
	PlayerCustomSpawn[playerid] = CallRemoteFunction("GetLastPCSStatus","i",playerid);
	PlayerCustomSpawn_X[playerid] = CallRemoteFunction("GetLastPCSStatus_X","i",playerid);
	PlayerCustomSpawn_Y[playerid] = CallRemoteFunction("GetLastPCSStatus_Y","i",playerid);
	PlayerCustomSpawn_Z[playerid] = CallRemoteFunction("GetLastPCSStatus_Z","i",playerid);
	PlayerCustomSpawn_F[playerid] = CallRemoteFunction("GetLastPCSStatus_F","i",playerid);
	PlayerCustomSpawn_I[playerid] = CallRemoteFunction("GetLastPCSStatus_I","i",playerid);
	//ApplyAnimation(playerid,"DANCING","DNCE_M_B",4.0,1,0,0,0,-1);

	if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) > 0)	{
		new pname[MAX_PLAYER_NAME],LogString[100],pIP[16];
		GetPlayerIp(playerid, pIP, sizeof(pIP));
		GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
		format(LogString, sizeof(LogString), "%s - [%i] - %s", pname, CallRemoteFunction("GetPlayerAdminLevel","i",playerid),pIP);
		CallRemoteFunction("SaveToFile","ss","ADMLogins",LogString);
	}
	

	new String[128];
	new texto[300];
	format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
	PlayerDados[playerid][Membro] = DOF2_GetInt(String, "Membro");
	PlayerDados[playerid][Lider] = DOF2_GetInt(String, "Lider");
	PlayerDados[playerid][Cargo] = DOF2_GetInt(String, "Cargo");
	if(ContaExiste(playerid))
	{
	    format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
	    PlayerDados[playerid][Lider] = DOF2_GetInt(String, "Lider");
	    PlayerDados[playerid][Membro] = DOF2_GetInt(String, "Membro");
	    PlayerDados[playerid][Cargo] = DOF2_GetInt(String, "Cargo");
	    format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Membro]);
	    if(!DOF2_FileExists(String)){
	        PlayerDados[playerid][Membro] = 0;
	        PlayerDados[playerid][Cargo] = 0;
 		}
	}
	if(!ContaExiste(playerid)){
	    format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
		DOF2_CreateFile(String);
		DOF2_SetInt(String, "Lider", PlayerDados[playerid][Lider]);
		DOF2_SetInt(String, "Membro", PlayerDados[playerid][Membro]);
		DOF2_SetInt(String, "Cargo", PlayerDados[playerid][Cargo]);
	}

	if(PlayerDados[playerid][Lider] > 0){
		format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
	    format(texto, sizeof(texto), "[GANG]: Membro da gang [%s] - Cargo: (%i)", DOF2_GetString(String, "Nome"), PlayerDados[playerid][Cargo]);
	    SendClientMessage(playerid, COLOUR_INFORMACAO, texto);
	}else if(PlayerDados[playerid][Membro] > 0){
	    format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Membro]);
	    format(texto, sizeof(texto), "[GANG]: Membro do CLA [%s] - Cargo: (%i)", DOF2_GetString(String, "Nome"), PlayerDados[playerid][Cargo]);
	    SendClientMessage(playerid, COLOUR_INFORMACAO, texto);
	}
}

public RandomMSGs(){
new string[128];
new random1 = random(sizeof(MSGs));
format(string, sizeof(string), "%s", MSGs[random1]);
SendClientMessageToAll(COLOUR_DICA,string);
return 1;}


public OnPlayerPickUpPickup(playerid, pickupid){
if(pickupid == pickupammu) {MostrarListaCompras(playerid);return 1;}

//CARROS VS PLAYERS GTA V BY MOTOXEX
if(PVC_Tipo == 0 && PVC_EmProgresso == 1){
	if(pickupid == PVC1){
		if(PVC_Vai[playerid] == 1 && ArenaTipo[playerid] == 69) {
			GivePlayerWeapon(playerid, 35, 10);
		}
	}if(pickupid == PVC2){
		if(PVC_Vai[playerid] == 1 && ArenaTipo[playerid] == 69) {
			GivePlayerWeapon(playerid, 35, 10);
		}
	}if(pickupid == PVC1){
		if(PVC_Vai[playerid] == 1 && ArenaTipo[playerid] == 69) {
			GivePlayerWeapon(playerid, 35, 10);
		}
	}if(pickupid == PVC3){
		if(PVC_Vai[playerid] == 1 && ArenaTipo[playerid] == 69) {
			GivePlayerWeapon(playerid, 35, 10);
		}
	}if(pickupid == PVC4){
		if(PVC_Vai[playerid] == 1 && ArenaTipo[playerid] == 69) {
			GivePlayerWeapon(playerid, 35, 10);
		}
	}if(pickupid == PVC5){
		if(PVC_Vai[playerid] == 1 && ArenaTipo[playerid] == 69) {
			GivePlayerWeapon(playerid, 35, 10);
		}
	}if(pickupid == PVC6){
		if(PVC_Vai[playerid] == 1 && ArenaTipo[playerid] == 69) {
			GivePlayerWeapon(playerid, 35, 10);
		}
	}
}else if(PVC_Tipo == 1 && PVC_EmProgresso == 1){
	if(pickupid == PVC1){
		if(PVC_Vai[playerid] == 1 && ArenaTipo[playerid] == 69) {
			GivePlayerWeapon(playerid, 34, 50);
		}
	}if(pickupid == PVC2){
		if(PVC_Vai[playerid] == 1 && ArenaTipo[playerid] == 69) {
			GivePlayerWeapon(playerid, 34, 50);
		}
	}if(pickupid == PVC3){
		if(PVC_Vai[playerid] == 1 && ArenaTipo[playerid] == 69) {
			GivePlayerWeapon(playerid, 34, 50);
		}
	}if(pickupid == PVC4){
		if(PVC_Vai[playerid] == 1 && ArenaTipo[playerid] == 69) {
			GivePlayerWeapon(playerid, 34, 50);
		}
	}if(pickupid == PVC5){
		if(PVC_Vai[playerid] == 1 && ArenaTipo[playerid] == 69) {
			GivePlayerWeapon(playerid, 34, 50);
		}
	}if(pickupid == PVC6){
		if(PVC_Vai[playerid] == 1 && ArenaTipo[playerid] == 69) {
			GivePlayerWeapon(playerid, 34, 50);
		}
	}
}

if(pickupid == PickGeral || pickupid == PickGeral2 || pickupid == PickGeral3)
{
GivePlayerWeapon(playerid, 22, 300);
GivePlayerWeapon(playerid, 28, 300);
GivePlayerWeapon(playerid, 31, 300);
GivePlayerWeapon(playerid, 16, 10);
GivePlayerWeapon(playerid, 34, 100);
GivePlayerWeapon(playerid, 4, 2);
GivePlayerWeapon(playerid, 42, 100);
GivePlayerWeapon(playerid, 26, 300);
SetPlayerArmour(playerid,100.0);
SendClientMessage(playerid,COLOUR_INFORMACAO,"[INFO]: Parabéns, você conseguiu um Kit de Guerra, o que inclui:");
SendClientMessage(playerid,COLOUR_INFORMACAO,"[INFO]: Colete, Faca, Granadas, M4, Sniper, Extintor e Kit Run");
return 1;
}

if(pickupid == PickGeral4){
GivePlayerWeapon(playerid, 24, 999);
GivePlayerWeapon(playerid, 28, 999);
GivePlayerWeapon(playerid, 31, 999);
GivePlayerWeapon(playerid, 16, 999);
GivePlayerWeapon(playerid, 34, 999);
GivePlayerWeapon(playerid, 4, 2);
GivePlayerWeapon(playerid, 42, 999);
GivePlayerWeapon(playerid, 26, 999);
SetPlayerArmour(playerid,100.0);
SendClientMessage(playerid,COLOUR_INFORMACAO,"[INFO]: Parabéns, você pegou o Kit dos DDR, o que inclui:");
SendClientMessage(playerid,COLOUR_INFORMACAO,"[INFO]: Colete, Faca, Granadas, M4, Sniper, Extintor e Kit Run com Desert");
return 1;
}

if(pickupid == PickBHD){
GivePlayerWeapon(playerid, 24, 999);
GivePlayerWeapon(playerid, 28, 999);
GivePlayerWeapon(playerid, 31, 999);
GivePlayerWeapon(playerid, 16, 999);
GivePlayerWeapon(playerid, 34, 999);
GivePlayerWeapon(playerid, 4, 2);
GivePlayerWeapon(playerid, 42, 999);
GivePlayerWeapon(playerid, 26, 999);
SendClientMessage(playerid,COLOUR_INFORMACAO,"[INFO]: Parabéns, você pegou o Kit dos BHD, o que inclui:");
SendClientMessage(playerid,COLOUR_INFORMACAO,"[INFO]: Colete, Faca, Granadas, M4, Sniper, Extintor e Kit Run com Desert");
return 1;
}

return 1;}

public OnFilterScriptInit() {
    for(new i; i < GetMaxPlayers(); i++) EnqueteVotou[i] = false;
	Enquete = false;
	EnqueteVotosSim = 0;
	EnqueteVotosNao = 0;

    return 1;
}

public OnFilterScriptExit()
{
    //DESTROY PICKUP CARROS VS PLAYERS GTA V BY MOTOXEX
	DestroyPickup(PVC1);
	DestroyPickup(PVC2);
	DestroyPickup(PVC3);
	DestroyPickup(PVC4);
	DestroyPickup(PVC5);
	DestroyPickup(PVC6);

	for(new i; i < GetMaxPlayers(); i++){
		PararGPS(i);
	}
	for(new i; i < GetMaxPlayers(); i++){
		KillTimer(GPS_Update_Timer[i]);
		KillTimer(COLOR_Update_Timer[i]);
	}

    for(new i; i < GetMaxPlayers(); i++) EnqueteVotou[i] = false;
	Enquete = false;
	EnqueteVotosSim = 0;
	EnqueteVotosNao = 0;
	DOF2_Exit();
return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate){



//Crasher Hack Detection
if(newstate == PLAYER_STATE_ONFOOT)
{
	if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
	{
	PreDefStateChanges[playerid]++;
	}
}

//ResetSpeedHackAlerter
SpeedHack[playerid] = false;

//CAPACETE MOTO
if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER){
if(IsABike(GetPlayerVehicleID(playerid))){
if(Capacete[playerid] == true){
SendClientMessage(playerid,COLOUR_DICA,"[INFO]: Você esta de capacete, para remover digite: /CAP");
switch(GetPlayerSkin(playerid)){
#define SPAO{%0,%1,%2,%3,%4,%5} SetPlayerAttachedObject(playerid, SLOTCAPACETE, 18645, 2, (%0), (%1), (%2), (%3), (%4), (%5));
case 0, 65, 74, 149, 208, 273:  SPAO{0.070000, 0.000000, 0.000000, 88.000000, 75.000000, 0.000000}
case 1..6, 8, 14, 16, 22, 27, 29, 33, 41..49, 82..84, 86, 87, 119, 289: SPAO{0.070000, 0.000000, 0.000000, 88.000000, 77.000000, 0.000000}
case 7, 10: SPAO{0.090000, 0.019999, 0.000000, 88.000000, 90.000000, 0.000000}
case 9: SPAO{0.059999, 0.019999, 0.000000, 88.000000, 90.000000, 0.000000}
case 11..13: SPAO{0.070000, 0.019999, 0.000000, 88.000000, 90.000000, 0.000000}
case 15: SPAO{0.059999, 0.000000, 0.000000, 88.000000, 82.000000, 0.000000}
case 17..21: SPAO{0.059999, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
case 23..26, 28, 30..32, 34..39, 57, 58, 98, 99, 104..118, 120..131: SPAO{0.079999, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
case 40: SPAO{0.050000, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000}
case 50, 100..103, 148, 150..189, 222: SPAO{0.070000, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000}
case 51..54: SPAO{0.100000, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000}
case 55, 56, 63, 64, 66..73, 75, 76, 78..81, 133..143, 147, 190..207, 209..219, 221, 247..272, 274..288, 290..293: SPAO{0.070000, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
case 59..62: SPAO{0.079999, 0.029999, 0.000000, 88.000000, 82.000000, 0.000000}
case 77: SPAO{0.059999, 0.019999, 0.000000, 87.000000, 82.000000, 0.000000}
case 85, 88, 89: SPAO{0.070000, 0.039999, 0.000000, 88.000000, 82.000000, 0.000000}
case 90..97: SPAO{0.050000, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
case 132: SPAO{0.000000, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
case 144..146: SPAO{0.090000, 0.000000, 0.000000, 88.000000, 82.000000, 0.000000}
case 220: SPAO{0.029999, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
case 223, 246: SPAO{0.070000, 0.050000, 0.000000, 88.000000, 82.000000, 0.000000}
case 224..245: SPAO{0.070000, 0.029999, 0.000000, 88.000000, 82.000000, 0.000000}
case 294: SPAO{0.070000, 0.019999, 0.000000, 91.000000, 84.000000, 0.000000}
case 295: SPAO{0.050000, 0.019998, 0.000000, 86.000000, 82.000000, 0.000000}
case 296..298: SPAO{0.064999, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000}
case 299: SPAO{0.064998, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}}
}}}else{RemovePlayerAttachedObject(playerid, SLOTCAPACETE);}

if(oldstate == PLAYER_STATE_DRIVER && newstate != PLAYER_STATE_DRIVER && NoEvento[playerid] == 1 && EventoAtivo == 1 && EventoMatarAoSairVeiculo == 1){
SetPlayerHealth(playerid,0.0);}

if(oldstate == PLAYER_STATE_DRIVER && newstate != PLAYER_STATE_DRIVER && NoEvento[playerid] == 1 && EventoMatarAoSairDerby[playerid] == 1){
SetPlayerHealth(playerid,0.0);}

if(newstate == PLAYER_STATE_DRIVER){
if(GetPlayerVehicleID(playerid) == HydraGM){
new SACSB[100];new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(SACSB, sizeof(SACSB), "[ADM]: %s (%i) pegou o hydra do servidor", pname, playerid);
CallRemoteFunction("MessageToAdmins","is",COLOUR_AVISO,SACSB);}}

if(newstate == PLAYER_STATE_DRIVER){
if(GetPlayerVehicleID(playerid) == SeaspGM){
new SACSB[100];new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(SACSB, sizeof(SACSB), "[ADM]: %s (%i) pegou o seasparrow do servidor", pname, playerid);
CallRemoteFunction("MessageToAdmins","is",COLOUR_AVISO,SACSB);}}

//ANTI-ARMAS ILEGAIS COMO PASSENGER - DESERT E SNIPER
if(newstate == PLAYER_STATE_PASSENGER){
new weap = GetPlayerWeapon(playerid);
if(weap == 24 || weap == 34){SetPlayerArmedWeapon(playerid,0);}}

//ANTI-DB
if(newstate == PLAYER_STATE_DRIVER){SetPlayerArmedWeapon(playerid,0);}
if(newstate == PLAYER_STATE_PASSENGER){
new EmMoto = 0;
switch(GetVehicleModel(GetPlayerVehicleID(playerid))){
case 509: EmMoto = 1;
case 481: EmMoto = 1;
case 510: EmMoto = 1;
case 462: EmMoto = 1;
case 448: EmMoto = 1;
case 581: EmMoto = 1;
case 522: EmMoto = 1;
case 461: EmMoto = 1;
case 521: EmMoto = 1;
case 523: EmMoto = 1;
case 463: EmMoto = 1;
case 586: EmMoto = 1;
case 468: EmMoto = 1;
case 471: EmMoto = 1;}
if(EmMoto == 1){SetPlayerArmedWeapon(playerid,0);}}

//REGISTRAR A ID DO ULTIMO VEICULO USADO
if(newstate == PLAYER_STATE_DRIVER){UltimoVeiculoUsado[playerid] = GetPlayerVehicleID(playerid);}

//ANTI-BUG QUANDO ENTRAM PASSAGEIROS (TRANCADO)
if(newstate == PLAYER_STATE_PASSENGER || newstate == PLAYER_STATE_DRIVER){
if(vtrancado[GetPlayerVehicleID(playerid)] == 1 && veiculo[playerid] != GetPlayerVehicleID(playerid)){
new Float:playerposx, Float:playerposy, Float:playerposz;
GetPlayerPos(playerid, playerposx, playerposy, playerposz);
SetPlayerPos(playerid,playerposx, playerposy, playerposz+2);
RemovePlayerFromVehicle(playerid);
SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Este veículo está trancado");}}

//NOME DO VEICULO
if(newstate == PLAYER_STATE_DRIVER && oldstate != PLAYER_STATE_DRIVER){
new str[50];
format(str, sizeof(str), "~r~%s",VehicleNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400]);
GameTextForPlayer(playerid, str, 6000, 1);}

//NOME DO DONO NO VEICULO
if(UltimoVeiculoUsado[playerid] == veiculo[playerid]){
if(newstate == PLAYER_STATE_DRIVER){OcultarDonoDoVeiculo(playerid);}
if(oldstate == PLAYER_STATE_DRIVER){MostrarDonoDoVeiculo(playerid);}}

//TOW TRUCK
if(newstate == PLAYER_STATE_DRIVER){
if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 525 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 531){
SendClientMessage(playerid,COLOUR_DICA,"[INFO]: Você pode rebocar veículos com a tecla CTRL");}}

//ULTRA GC ATIVADO ENTRANDO NO VEICULO
if(newstate == PLAYER_STATE_DRIVER){
if(UltraGC[playerid] == 1){
GetPlayerHealth(playerid, Float:UltraGC_VIDA[playerid]);
GetPlayerArmour(playerid, Float:UltraGC_COLETE[playerid]);
SetPlayerHealth(playerid,100.0);
SetPlayerArmour(playerid,0.0);}}

//ULTRA GC ATIVADO SAINDO DO VEICULO
if(oldstate == PLAYER_STATE_DRIVER && newstate != PLAYER_STATE_DRIVER){
if(UltraGC[playerid] == 1){
SetPlayerHealth(playerid,Float:UltraGC_VIDA[playerid]);
SetPlayerArmour(playerid,Float:UltraGC_COLETE[playerid]);}}

//FRACASSAR A MISSÃO
if(oldstate == PLAYER_STATE_DRIVER && newstate != PLAYER_STATE_DRIVER){
if(VPlayerMissao[playerid] != 0){
DisablePlayerCheckpoint(playerid);
VPlayerMissao[playerid] = 0;
SendClientMessage(playerid, COLOUR_AVISO, "[AVISO]: Missão fracassada! (Saiu do veículo)");
GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~r~MISSAO FRACASSADA!", 5000, 5);}}

//VEICULOS DE MISSÃO
if(newstate == PLAYER_STATE_DRIVER){
switch(GetVehicleModel( GetPlayerVehicleID(playerid))){
case 530,411,541,494,451,478,448,437,431,407,420,416,
438,427,574,409,428,414,592,577,511,512,593,520,553,
476,519,460,513,537,538,449,548,425,417,487,488,497,
563,447,469,596,598,597,599,442,525,588,524,403,514,
515,531,572,486,455,578,609,532,475,576,408,552,423,
509,481,510,582,468,586,463,521,461,581:{
SendClientMessage(playerid, COLOUR_DICA,"[INFO]: Para fazer uma missão com este veículo digite: /MIS");
SendClientMessage(playerid, COLOUR_INFORMACAO ,"[INFO]: Você quer xenon para seu veículo? Use: /XENON para ver as cores!");}}}

//POLICIA X LADRAO
if(newstate == PLAYER_STATE_DRIVER){
    new modelo = GetVehicleModel(GetPlayerVehicleID(playerid));
	if(modelo == 535){
		if(PL_EmProgresso == 1 && PL_Vai[playerid] == 1 && PL_Team[playerid] == 2){
			GodCarOn[playerid] = 1;
			SendClientMessage(playerid, COLOUR_INFORMACAO, " ");
	 		SendClientMessage(playerid, COLOUR_INFORMACAO, "[PL]: Voce pegou o carro definido!");
  			SendClientMessage(playerid, COLOUR_INFORMACAO, "[PL]: Leve ate o checkpoint vermelho no mapa! Boa sorte!!");
  			SendClientMessage(playerid, COLOUR_INFORMACAO, " ");
			for(new i; i < GetMaxPlayers(); i++){
				if(IsPlayerConnected(i)){
				    if(PL_Vai[i] == 1){
						SetPlayerCheckpoint(i, -2261.4451,2297.1990,4.8202, 6.0);
					}
				}
			}
		}
	}
}

//RADAR DE COMBATE
if(newstate == PLAYER_STATE_DRIVER){if(IsACombatVehicle(GetPlayerVehicleID(playerid))){SendClientMessage(playerid, COLOUR_DICA, "[INFO]: Este veículo está equipado com: /RADAR");}}

if(MostrandoVelocimetro[playerid] == 1){
//MOSTRAR VELOCIMETRO - ENTRANDO NO VEICULO

if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER){
TextDrawShowForPlayer(playerid,TXTVELOCIDADE[playerid]);}

//OCULTAR VELOCIMETRO - SAINDO DO VEICULO
if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER){
TextDrawHideForPlayer(playerid,TXTVELOCIDADE[playerid]);}}

//VERIFICAR SE O PLAYER ESTA EM RC E DAR A DICA DO CMD PARA SAIR
if(newstate == PLAYER_STATE_DRIVER){
new modelo = GetVehicleModel(GetPlayerVehicleID(playerid));
if(modelo == 441 || modelo == 464 || modelo == 465 || modelo == 501 || modelo == 564){
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Use o comando /SAIRRC para sair deste veículo");}}

//ADICIONAL - JOGADOR DENTRO DO VEICULO COMO MOTORISTA
if(newstate == PLAYER_STATE_DRIVER){
if(AutoTrancar[playerid] == 1){
if(GetPlayerVehicleID(playerid) == veiculo[playerid]){
SendClientMessage(playerid, COLOUR_DICA,"[INFO]: Seu veículo está trancado. Para destrancar: /destrancar");}}
new st = 0;switch(GetVehicleModel( GetPlayerVehicleID(playerid) )) {
case 592,577,511,512,593,520,553,476,519,460,513,548,
425,417,487,488,497,563,447,469,472,473,493,595,484,
430,453,452,446,454,441,464,465,501,564,594,432:st = 1;}
if(GodCarOn[playerid] == 0){if(st == 0){SendClientMessage(playerid, COLOUR_DICA,"[INFO]: Digite /gc para deixar seu veiculo invulneravel (godcar) ");}}
Reparar[playerid] = 0;}

//ADICIONAR NITRO AO VEICULO
if(GetPlayerState(playerid)== PLAYER_STATE_DRIVER){
new vehicleid=GetPlayerVehicleID(playerid);
if(CheckVehicle(vehicleid))
AddVehicleComponent(vehicleid,1010);}

return 1;}

forward MapaMaze();

public OnPlayerStreamIn(playerid, forplayerid)
{
    if(NickEsconder[playerid] == 1)
    {
        ShowPlayerNameTagForPlayer(forplayerid, playerid, false);
    }
    if(NickEsconder[playerid] != 1)
    {
        ShowPlayerNameTagForPlayer(forplayerid, playerid, true);
    }
    return 1;
}

public OnPlayerUpdate(playerid)
{

//labirinto
	if(IsPlayerInRangeOfPoint(playerid, 7.0, 651.9136,-2825.4656,46.4523))
	{
	new string[120];
	if(!IsPlayerSpawned(playerid)){return 1;}
	if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
	if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
	if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
	if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
	if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
	if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
	new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
	format(string, sizeof(string), "{FF387A}%s {85FFAF}completou e ganhou o premio no LABIRINTO", pname);
	SendClientMessageToAll(COLOUR_TELEPORTE, string);
	SetCameraBehindPlayer(playerid);
	ProgramarAntiFlood(playerid);
	SpawnPlayer(playerid);
	GameTextForPlayer(playerid,"Parabens!! Voce concluiu o Labirinto",5000,1);
    CallRemoteFunction("GivePlayerCash", "ii", playerid, 500000);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você ganhou $500.000");
   	SetPVarInt(playerid,"InMaze",0);
	}

//Contador de mudanças de veículo para anti-cheater
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
{
	if(GetPlayerVehicleID(playerid) != LastVehicleModel[playerid])
	{
	LastVehicleModel[playerid] = GetPlayerVehicleID(playerid);
	VChanges[playerid]++;
	}
}

//Contador de FPS
new drunknew = GetPlayerDrunkLevel(playerid);
if(drunknew < 100){SetPlayerDrunkLevel(playerid, 2000);}else{
if(pDrunkLevelLast[playerid] != drunknew){
new wfps = pDrunkLevelLast[playerid] - drunknew;
if((wfps > 0) && (wfps < 200))
pFPS[playerid] = wfps;
SetPVarInt(playerid, "PVarFPS", pFPS[playerid]);
pDrunkLevelLast[playerid] = drunknew;}}

//Comando Bugar
if(Bugar[playerid] == true) {return 0;}

return 1;
}

/*stock IniciarAssistir(playerid, specplayerid)
{
	SetPlayerInterior(playerid,GetPlayerInterior(specplayerid));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(specplayerid));
	TogglePlayerSpectating(playerid, 1);

	if(IsPlayerInAnyVehicle(specplayerid)) {
		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(specplayerid));
	}
	else {
		PlayerSpectatePlayer(playerid, specplayerid);
	}
	return 1;
}

stock PararAssistir()
{
	for(new i; i<MAX_PLAYERS; i++){
		if(IsPlayerConnected(i)){
			if(Assistindo[i] == true){
                TogglePlayerSpectating(i, 0);
                Assistindo[playerid] = false;
			}
		}
	}
	return 1;
}
*/
stock IsPlayerInWater(playerid) {
        new anim = GetPlayerAnimationIndex(playerid);
        if (((anim >=  1538) && (anim <= 1542)) || (anim == 1544) || (anim == 1250) || (anim == 1062)) return 1;
        return 0;
}

stock IsPlayerAiming(playerid) {
new anim = GetPlayerAnimationIndex(playerid);
if (((anim >= 1160) && (anim <= 1163)) || (anim == 1167) || (anim == 1365) ||
(anim == 1643) || (anim == 1453) || (anim == 220)) return 1;
return 0;
}

strtok(const string[], &index)
{
        new length = strlen(string);
        while ((index < length) && (string[index] <= ' '))
        {
                index++;
        }

        new offset = index;
        new result[20];
        while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
        {
                result[index - offset] = string[index];
                index++;
        }
        result[index - offset] = EOS;
        return result;
}

stock GetName(playerid)
{
	new name[24];
	GetPlayerName(playerid,name,24);
	return name;
}

stock ContagemDuel(p1,p2)
{
	TogglePlayerControllable(p1,0);
	TogglePlayerControllable(p2,0);
	GameTextForPlayer(p1,"3",1000,6);
	GameTextForPlayer(p2,"3",1000,6);
	PlayerPlaySound(p1,1056,0,0,0);
	PlayerPlaySound(p2,1056,0,0,0);
	SetTimerEx("Cont",1000,false,"iii",p1,p2,2);
}

stock ContagemPL(p1)
{
	TogglePlayerControllable(p1,0);
	GameTextForPlayer(p1,"3",1000,6);
	PlayerPlaySound(p1,1056,0,0,0);
	SetTimerEx("ContPL",1000,false,"iii",p1,2);
}

stock ContagemPVC(playerid)
{
	TogglePlayerControllable(playerid,0);
	GameTextForPlayer(playerid,"3",1000,6);
	PlayerPlaySound(playerid,1056,0,0,0);
	SetTimerEx("ContPVC",1000,false,"iii",playerid,2);
}

stock EndDuel(winner,loser)
{
	Duel[winner] = 998;
	Duel[loser] = 998;
	Player[winner][wins] ++;
	Player[loser][losses] ++;
	SetPlayerTeam(winner,1);
	SetPlayerTeam(loser,1);
	new wl[500];
	new Float:life,Float:armour;
	GetPlayerArmour(winner,armour);
	GetPlayerHealth(winner,life);

	if(life == 100 && armour == 100){
        format(wl, sizeof(wl), "{00FF00}[DUEL] {FFFFFF}%s {00FF00}derrotou {FFFFFF}%s {00FF00}de {00FF6E}[PERFECT]", GetName(winner),GetName(loser));
		SendClientMessageToAll(COLOUR_INFORMACAO,wl);
	}else{
        format(wl, sizeof(wl), "{00FF00}[DUEL] {FFFFFF}%s {00FF00}derrotou {FFFFFF}%s {00FF00}restando {00FF6E}[COLETE: %.0f/ VIDA: %.0f]", GetName(winner),GetName(loser), armour, life);
		SendClientMessageToAll(COLOUR_INFORMACAO,wl);
	}
	Arena[winner] = 0;
	Arena[loser] = 0;
	DuelArena[winner] = false;
    DuelArena[loser] = false;
 	SetPlayerVirtualWorld(winner,0);
	SetPlayerInterior(winner,0);
	SetPlayerHealth(winner,100);
	SetPlayerArmour(winner,100);
	SpawnPlayer(winner);
	return 1;
}

stock ProcessarBOT(playerid)
{
BotTolerance++;
if(BotTolerance >= 5) BanBot(playerid);
}

stock BanBot(playerid)
{
new str_hack[128],pnamehack[MAX_PLAYER_NAME];
GetPlayerName(playerid, pnamehack, sizeof(pnamehack));
format(str_hack, sizeof(str_hack), "[ADM]: BOT/CONNECT FLOOD bloqueado: %s (%i) - [BANIDO]", pnamehack, playerid);
CallRemoteFunction("MessageToAdmins","is",COLOUR_AVISO,str_hack);
print(str_hack);
CallRemoteFunction("SaveToFile","ss","BotFlood",str_hack);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[SERVER]: Seu IP foi banido por tentar conectar 5x em menos de 2 segundos de forma seguida.");
BanEx(playerid, "Flood/Reconnect");
}


public OnPlayerConnect(playerid)
{

//REMOVE
RemoveBuildingForPlayer(playerid, 8498, 2231.8047, 1035.7188, 46.8203, 0.25);
RemoveBuildingForPlayer(playerid, 8705, 2231.8047, 1035.7188, 46.8203, 0.25);
RemoveBuildingForPlayer(playerid, 1350, 1871.6953, 1722.9063, 9.8125, 0.25);
RemoveBuildingForPlayer(playerid, 1294, 2087.6641, 968.9063, 14.2734, 0.25);
RemoveBuildingForPlayer(playerid, 1350, 2137.2422, 967.6484, 9.7422, 0.25);
RemoveBuildingForPlayer(playerid, 1294, 2147.1094, 977.3281, 14.2734, 0.25);
RemoveBuildingForPlayer(playerid, 1350, 2157.5078, 978.7734, 9.7969, 0.25);
RemoveBuildingForPlayer(playerid, 1294, 2187.2891, 969.1641, 14.2734, 0.25);
RemoveBuildingForPlayer(playerid, 1294, 2229.3438, 977.3281, 14.2734, 0.25);
RemoveBuildingForPlayer(playerid, 1350, 2277.2813, 967.6563, 9.7969, 0.25);
RemoveBuildingForPlayer(playerid, 3460, 1853.6641, 1764.6016, 13.0234, 0.25);
//REMOVE ENTRADA DA BASE DOS ADM
RemoveBuildingForPlayer(playerid, 7538, 1859.8281, 2848.7656, 12.0469, 0.25);
RemoveBuildingForPlayer(playerid, 7423, 1524.5547, 2773.2266, 9.8203, 0.25);

//REMOVER ARVORES ARENA CAÇADA BY MOTOXEX
RemoveBuildingForPlayer(playerid, 785, 695.8203, -350.1563, 5.3906, 0.25);
RemoveBuildingForPlayer(playerid, 785, 637.6406, -328.6875, 10.3203, 0.25);

new dialogo[1000];
strins(dialogo,"{B33434}Bem-Vindo ao MUNDO DOS PIKAS!\n\n",strlen(dialogo));
strins(dialogo,"{D90048}>> {FFFFFF}Adicione nosso IP aos favoritos!\n",strlen(dialogo));
strins(dialogo,"{D90048}>> {FFFFFF}Participe de nosso grupo no facebook!\n",strlen(dialogo));
strins(dialogo,"{D90048}>> {FFFFFF}www.facebook.com/groups/1104937692859642/\n",strlen(dialogo));
strins(dialogo,"{D90048}>> {FFFFFF}Veja os /comandos, /teles\n",strlen(dialogo));
strins(dialogo,"{D90048}>> {FFFFFF}Para desligar a rádio, /off\n",strlen(dialogo));
ShowPlayerDialog(playerid,8439, DIALOG_STYLE_MSGBOX, "{B33434}• MUNDO DOS PIKAS •",dialogo, "Fechar", "");

ccolete[playerid] = 0;
vida[playerid]= 0;
InitFly(playerid);
PararGPS(playerid);
AGps[playerid] = false;

new randmsc = random(6);
		switch(randmsc)
		{
			case 0:	{
				PlayAudioStreamForPlayer(playerid, "http://dl.dropboxusercontent.com/s/glx5elcii3wnuud/Rae%20Sremmurd%20-%20Black%20Beatles%20ft.%20Gucci%20Mane.mp3");

			}
			case 1: {
				PlayAudioStreamForPlayer(playerid, "http://dl.dropboxusercontent.com/s/9pjkfm18yyo4u3y/Alan%20Walker%20-%20Faded.mp3");
			}
			case 2:{
				PlayAudioStreamForPlayer(playerid, "http://dl.dropboxusercontent.com/s/i9spmzw1hpcc3md/Justin%20Bieber%20ft.%20Major%20Lazer%20-%20Cold%20Water.mp3");
			}
			case 3:{
				PlayAudioStreamForPlayer(playerid, "http://dl.dropboxusercontent.com/s/r3bftykxyfwcdzo/Kid%20Cudi%20-%20Day%20%27N%27%20Nite%20%28Andrew%20Luce%20Remix%29.mp3");
			}
			case 4:{
				PlayAudioStreamForPlayer(playerid, "http://dl.dropboxusercontent.com/s/y4gsb1xcyqba5l9/Marshmello%20-%20Alone%20%5BMonstercat%20Official%20Music%20Video%5D.mp3");
			}
			case 5:{
				PlayAudioStreamForPlayer(playerid, "http://dl.dropboxusercontent.com/s/1awr0ewpg42wn9o/Twenty%20One%20Pilots%20-%20Heathens.mp3");
			}
		}


GameTextForPlayer(playerid, "~g~CARREGANDO...", 6000, 5);
TextDrawShowForPlayer(playerid, ImagemEntrada);
if(strcmp(PlayerIp(playerid),LastIPConnected,true) == 0 && TickCounter - LastConnectionTick <= 2) ProcessarBOT(playerid); else BotTolerance = 0; //Proteção contra ataques BOT
if(strcmp(PlayerIp(playerid),"255.255.255.255",true) == 0) print("[INFO]: IP invalido na conexao acima"); else format(LastIPConnected, sizeof(LastIPConnected), "%s", PlayerIp(playerid));
if(IsPlayerNPC(playerid)) BanEx(playerid, "NPC");//AntiNPC
LastConnectionTick = TickCounter;
VChanges[playerid] = 0;
LastVChanges[playerid] = 0;
LastVehicleModel[playerid] = 0;
PontoAT[playerid] = false;
PontoU[playerid] = false;
ShowLogLines[playerid] = 0;
MostrandoFPSPing[playerid] = false;
SNP2[playerid] = false;
DamageTick[playerid] = 0;
Derby[playerid] = 0;
AntiRojao[playerid] = false;
Altimetro[playerid] = false;
Mecanica[playerid] = false;
OuvindoRadio[playerid] = true;
EventoMatarAoSairDerby[playerid] = 0;
PreDefStateChanges[playerid] = 0;
L_PreDefStateChanges[playerid] = 0;
Txverifica[playerid] = 1;
SpeedHack[playerid] = false;
ChamadoParaX1Por[playerid] = -1;
LastDeathTick[playerid] = TickCounter;
CX1Tipo[playerid] = 0;
Bugar[playerid] = false;
AwaySeconds[playerid] = 0;
AFK[playerid] = false;
ADMTick[playerid] = -100;
X1CTick[playerid] = -100;
LastDarGranaPos[playerid] = 0;
ScoreNaSessao[playerid] = 0;
noTotForest[playerid] = 0;
Neon[0][playerid] = -1;
Neon[1][playerid] = -1;
StuntSuperSpeed[playerid] = false;
TextoHead[playerid] = Create3DTextLabel(" ",0x0083ADFF,0,0,0,60,0,0);
TextoVeiculo[playerid] = Create3DTextLabel(" ",0xFF8408FF,0,0,0,20,0,0);
Attach3DTextLabelToPlayer(TextoHead[playerid], playerid, 0.0, 0.0, 0.7);
new pname[MAX_PLAYER_NAME], string[128];
GetPlayerName(playerid, pname, sizeof(pname));
if (strlen(pname) > 2)
{
format(string, sizeof(string), "{FF0000}[ID:%i] ---> {FF387A}%s {B33434}entrou no servidor!",playerid,pname);
SendClientMessageToAllEx(playerid, 0xAAAAAAAA, string);
SendDeathMessage(INVALID_PLAYER_ID, playerid, 200);
}
SetPlayerColor(playerid, playerColors[playerid]);
NewKillerID[playerid] = INVALID_PLAYER_ID;
LastKillerID[playerid] = INVALID_PLAYER_ID;
SendoAbusado[playerid] = 0;
KillSpree[playerid] = 0;
AF_UltimoComando[playerid] = 0;
SorteiosFeitos[playerid] = 0;
KillTimer(TimerKillSpree[playerid]);
KillTimer(AAD_DominandoTimer[playerid]);
PlayerCustomSpawn[playerid] = 0;
PlayerCustomSpawn_X[playerid] = 0;
PlayerCustomSpawn_Y[playerid] = 0;
PlayerCustomSpawn_Z[playerid] = 0;
PlayerCustomSpawn_F[playerid] = 0;
PlayerCustomSpawn_I[playerid] = 0;
VPlayerMissao[playerid] = 0;
NoEvento[playerid] = 0;
HeliKills[playerid] = 0;
KillTimer(TimerSoltar[playerid]);
UltimoVeiculoUsado[playerid] = 0;
veiculo[playerid] = 0;
vtrancado[veiculo[playerid]] = 0;
AutoTrancar[playerid] = 0;
Spree[playerid] = 0;
Arena[playerid] = 0;
ArenaTipo[playerid] = 0;
Reparar[playerid] = 0;
GodCarOn[playerid] = 0;
Rojoes[playerid] = 3;
transferencias[playerid] = 0;
cor[playerid] = 0;
skin[playerid] = 0;
UltraGC[playerid] = 0;
AAD_Vai[playerid] = 0;
PL_Vai[playerid] = 0;
PVC_Vai[playerid] = 0;
AutoPaintOn[playerid] = 0;
MostrandoVelocimetro[playerid] = 1;
MostrandoStatus[playerid] = 1;
XuxaPC[playerid] = 0;
Weather[playerid] = 0;
DistanciaMis[playerid] = 0;
DistanciaMis2[playerid] = 0;
pDrunkLevelLast[playerid] = 0;
pFPS[playerid] = 0;
PiscarLuzes[playerid] = false;
PiscarLuzesState[playerid] = false;
Capacete[playerid] = true;
NascerComColete[playerid] = false;
NascerColeteGratis[playerid] = true;
NascerComKw[playerid] = false;
NascerComKr[playerid] = false;
NascerComTp[playerid] = false;
NascerComKitGuerra[playerid] = false;
UsandoTXTPlaca[playerid] = false;
Gay[playerid] = false;

//LIMPAR ATTACHS
RemoverTodosAttachsObj(playerid);

//LOADER
KillTimer(TeleLockTimer[playerid]);
TogglePlayerControllable(playerid,1);

//Velocimetro
TextDrawHideForPlayer(playerid,TXTVELOCIDADE[playerid]);

SendClientMessage(playerid, COLOUR_BRANCO,"{B33434}|____________________________________________________________________________________|");
SendClientMessage(playerid, COLOUR_BRANCO,"{B33434}BEM VINDO AO MUNDO DOS PIKAS [MdP]");
SendClientMessage(playerid, COLOUR_BRANCO,"{00FF1E}FIQUE ATENTO AS {FFFFFF}/REGRAS{00FF1E} - VEJA OS {FFFFFF}/TELES {00FF1E}E {FFFFFF}/COMANDOS");
SendClientMessage(playerid, COLOUR_BRANCO,"{00FF1E}NUNCA FALE MAL DE UM ADMIN, ELE SEMPRE ESTARA FAZENDO O MELHOR PARA VOCE!");
SendClientMessage(playerid, COLOUR_BRANCO,"{00FF1E}EM CASO DE DUVIDAS, FALE COM ADMS, {FFFFFF}/ADMINS");
SendClientMessage(playerid, COLOUR_BRANCO,"{B33434}|____________________________________________________________________________________|");
return 1;}

public OnPlayerDisconnect(playerid, reason)
{

//XENON
if(Xenon[playerid] == 1){
		if(XenonVerifica[playerid] == 0){
				DestroyObject(Xenons[playerid][0]);
				DestroyObject(Xenons[playerid][1]);
				XenonContagem--;
				XenonContagem--;
		}
		if(XenonVerifica[playerid] == 1){
				DestroyObject(Xenons[playerid][2]);
				DestroyObject(Xenons[playerid][3]);
				XenonContagem--;
				XenonContagem--;
		}
		if(XenonVerifica[playerid] == 2){
				DestroyObject(Xenons[playerid][4]);
				DestroyObject(Xenons[playerid][5]);
				XenonContagem--;
				XenonContagem--;
		}
		if(XenonVerifica[playerid] == 3){
				DestroyObject(Xenons[playerid][6]);
				DestroyObject(Xenons[playerid][7]);
				XenonContagem--;
				XenonContagem--;
		}
		if(XenonVerifica[playerid] == 4){
				DestroyObject(Xenons[playerid][8]);
				DestroyObject(Xenons[playerid][9]);
				DestroyObject(Xenons[playerid][10]);
				DestroyObject(Xenons[playerid][11]);
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
		}
  		if(XenonVerifica[playerid] == 5){
				DestroyObject(Xenons[playerid][12]);
				DestroyObject(Xenons[playerid][13]);
				DestroyObject(Xenons[playerid][14]);
				DestroyObject(Xenons[playerid][15]);
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
		}
		if(XenonVerifica[playerid] == 6){
				DestroyObject(Xenons[playerid][16]);
				DestroyObject(Xenons[playerid][17]);
				DestroyObject(Xenons[playerid][18]);
				DestroyObject(Xenons[playerid][19]);
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
		}
		Xenon[playerid]=0;
}
SalvarDados(playerid);
//LABIRINTO
DOF2_Exit();
SetPVarInt(playerid,"InMaze",0);
Bugar[playerid] = false;
DestroyNeons(playerid,false);
PararGPS(playerid);
AGps[playerid] = false;
RemovePlayerAttachedObject(playerid, 0);
PreDefStateChanges[playerid] = 0;
L_PreDefStateChanges[playerid] = 0;


for(new i; i < GetMaxPlayers(); i++)
{
	if(IsPlayerConnected(i))
	{
	    //Limpar oponente do X1
		if(ChamadoParaX1Por[i] == playerid)
		{
		ChamadoParaX1Por[i] = -1;
		CX1Tipo[playerid] = 0;
		}
	}
}

//Anti-RQ
if(reason != 2)
{
	new Float:Vida,Float:Colete;
	GetPlayerHealth(playerid, Float:Vida);
	GetPlayerArmour(playerid, Float:Colete);
	//Verificar fora das arenas
	if(Vida < 25 && Colete < 1 && Spree[playerid] > 9 && Arena[playerid] == 0 && TickCounter - DamageTick[playerid] <= 5)
 {
		new Float:px,Float:py, Float:pz, PlayersPerto;
		GetPlayerPos(playerid, px, py, pz);
		for(new i; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i)) if(IsPlayerInRangeOfPoint(i, 25.0, px, py, pz)) PlayersPerto++;

			if(PlayersPerto > 0)
			{
			new RQString[100],pname[MAX_PLAYER_NAME];
			GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
			format(RQString, sizeof(RQString), "[ADM]: %s (%i) suspeito de ter feito Rage-Quit (Alta possibilidade!)", pname, playerid);
			CallRemoteFunction("MessageToAdmins","is",COLOUR_AVISO,RQString);
			}
	}

    //Verificar dentro das arenas
	if(Vida < 20 && Colete < 1 && Arena[playerid] == 1 && TickCounter - DamageTick[playerid] <= 3)
	{
	new RQString[100],pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
	format(RQString, sizeof(RQString), "[ADM]: %s (%i) suspeito de ter feito Rage-Quit (Na arena)", pname, playerid);
	CallRemoteFunction("MessageToAdmins","is",COLOUR_AVISO,RQString);
	}

}

//LIMPAR ATTACHS
RemoverTodosAttachsObj(playerid);

//APAGAR 3D TEXT's
if(TextoHead[playerid] != Primeiro3DTXT) Delete3DTextLabel(TextoHead[playerid]);
if(TextoVeiculo[playerid] != Primeiro3DTXT) Delete3DTextLabel(TextoVeiculo[playerid]);

if(UsandoTXTPlaca[playerid] == true){
Delete3DTextLabel(TXTPlaca[playerid]);
UsandoTXTPlaca[playerid] = false;}

//ESCONDER TEXTS E PARAR MUSICA - KICKADOS OU BANIDOS
TextDrawHideForPlayer(playerid, TDEditor_TD[0]);
TextDrawHideForPlayer(playerid, TDEditor_TD[1]);
TextDrawHideForPlayer(playerid, TDEditor_TD[2]);
TextDrawHideForPlayer(playerid, TDEditor_TD[3]);
TextDrawHideForPlayer(playerid, TDEditor_TD[4]);
TextDrawHideForPlayer(playerid, TDEditor_TD[5]);
TextDrawHideForPlayer(playerid, TDEditor_TD[6]);
TextDrawHideForPlayer(playerid, Textdraw7);
TextDrawHideForPlayer(playerid, Textdraw8);
TextDrawHideForPlayer(playerid, Textdraw10);
TextDrawHideForPlayer(playerid, Textdraw3);
TextDrawHideForPlayer(playerid, Textdraw25);
TextDrawHideForPlayer(playerid, Textdraw26);
TextDrawHideForPlayer(playerid, Textdraw27);
TextDrawHideForPlayer(playerid, Textdraw28);
TextDrawHideForPlayer(playerid, Textdraw29);
TextDrawHideForPlayer(playerid, Textdraw30);
TextDrawHideForPlayer(playerid,Status[playerid]);

//LOADER
KillTimer(TeleLockTimer[playerid]);

//OCULTAR VELOCIMETRO
TextDrawHideForPlayer(playerid,TXTVELOCIDADE[playerid]);

if(ArenaTipo[playerid] == 3){X1 = X1-1;ArenaTipo[playerid] = 0;}
if(ArenaTipo[playerid] == 8){X1W = X1W-1;ArenaTipo[playerid] = 0;}
Arena[playerid] = 0;

if(AAD_Vai[playerid] == 1) {AAD_Vai[playerid] = 0;}
if(PVC_Vai[playerid] == 1) {PVC_Vai[playerid] = 0;}
if(PL_Vai[playerid] == 1) {PL_Vai[playerid] = 0;}

KillSpree[playerid] = 0;
KillTimer(TimerKillSpree[playerid]);

KillTimer(TimerSoltar[playerid]);
KillTimer(TimerMV[playerid]);
preso[playerid] = 0;
ArenaTipo[playerid] = 0;
Reparar[playerid] = 0;
GodCarOn[playerid] = 0;
if(EventoAdminID == playerid && EventoAtivo == 1){EventoAtivo = 0;EventoAdminID = -1;EventoNome = "";}
new pname[MAX_PLAYER_NAME], string[128];
GetPlayerName(playerid, pname, sizeof(pname));
switch(reason)
{
case 0: format(string, sizeof(string), "{FF387A}%s {B33434}vou relogar! (CRASH/CONEXAO)", pname);
case 1: format(string, sizeof(string), "{FF387A}%s {B33434}saiu. Já volto pra matar mais!", pname);
//case 2: format(string, sizeof(string), "{00FF62}%s {FFFFFF}saiu do jogo. (Kickado ou banido)", pname);
}

if (strlen(pname) > 2 && (strlen(string)) > 1)
{
SendClientMessageToAllEx(playerid, 0xAAAAAAAA, string);
SendDeathMessage(INVALID_PLAYER_ID, playerid, 201);
}

if(veiculo[playerid] != 0){DestroyVehicle(veiculo[playerid]);vtrancado[veiculo[playerid]] = 0;veiculo[playerid] = 0;}
if(EventoVeiculo[playerid] != 0){DestroyVehicle(EventoVeiculo[playerid]);EventoVeiculo[playerid] = 0;}
veiculo[playerid] = 0;
EventoVeiculo[playerid] = 0;
}
IsPlayerSpawned(playerid){


new statex = GetPlayerState(playerid);
if(statex != PLAYER_STATE_NONE && statex != PLAYER_STATE_WASTED && statex != PLAYER_STATE_SPAWNED){
if(statex != PLAYER_STATE_SPECTATING)
{return true;}}return false;}

stock TemCarroPerto(playerid, Float:range)
{
	new Float:x, Float:y, Float:z;

	new v=0;
	while(v != MAX_VEHICLES){

	    GetVehiclePos(v, x, y, z);
	    if(IsPlayerInRangeOfPoint(playerid, range, x, y, z))
	    {
	        return 1;
	    }
	    v++;
	}

	return 0;
}

stock SetPlayerPosRandom(playerid, Float:x,Float:y,Float:z, randoness = 10)
{
new xrand, yrand, xpy, ypy;
new Float:pssx, Float:pssy;
xrand = random(randoness);
yrand = random(randoness);
xpy = random(2);
ypy = random(2);
if(xpy == 1) pssx = x + xrand; else pssx = x - xrand;
if(ypy == 1) pssy = y + yrand; else pssy = y - yrand;
SetPlayerPos(playerid,pssx,pssy,z);
return 1;
}

stock DistanciaAtePonto(playerid, Float:x2,Float:y2,Float:z2)
{
new Float:x1,Float:y1,Float:z1;
GetPlayerPos(playerid,x1,y1,z1);
return floatround(floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2)));
}

stock DesligarMonitores(playerid)
{
Mecanica[playerid] = false;
Altimetro[playerid] = false;
return;
}

stock IniciarGPS(playerid,rastreado)
{
	if(GPS_Ativo[playerid] == true) return 1;
	TextDrawSetString(Text:TextGPS1[playerid], "~w~INICIALIZANDO SISTEMA...");
	TextDrawSetString(Text:TextGPS2[playerid], "~w~BUSCANDO SATELITES...");
	TextDrawShowForPlayer(playerid, Text:TextGPS1[playerid]);
	TextDrawShowForPlayer(playerid, Text:TextGPS2[playerid]);
	GPS_Update_Timer[playerid] = SetTimerEx("GPS_Update", 1000, true, "ii", playerid, rastreado);
	COLOR_Update_Timer[playerid] = SetTimerEx("COLOR_Update", 250, true, "ii", playerid,rastreado);
	GPS_Ativo[playerid] = true;
	return 1;
}

stock PararGPS(playerid){
	if(GPS_Ativo[playerid] == false) return 1;
	KillTimer(GPS_Update_Timer[playerid]);
	KillTimer(COLOR_Update_Timer[playerid]);
	TextDrawHideForPlayer(playerid, Text:TextGPS1[playerid]);
	TextDrawHideForPlayer(playerid, Text:TextGPS2[playerid]);
	TextDrawSetString(Text:TextGPS1[playerid], "~w~INICIALIZANDO SISTEMA...");
	TextDrawSetString(Text:TextGPS2[playerid], "~w~BUSCANDO SATELITES...");
	for(new i; i < GetMaxPlayers(); i++) { Cores[i] = GetPlayerColor(i); SetPlayerMarkerForPlayer(playerid, i, Cores[i]);}
	GPS_Ativo[playerid] = false;
	return 1;
}

stock GetPlayerZone(Gplayerid){
	new Float:x,Float:y,Float:z;
	GetPlayerPos(Gplayerid,x,y,z);
	for(new i = 0; i < sizeof(Zones); i++){
		if(x > Zones[i][zone_minx] && y > Zones[i][zone_miny] && z > Zones[i][zone_minz] && x < Zones[i][zone_maxx] && y < Zones[i][zone_maxy] && z < Zones[i][zone_maxz])
		return i;
	}
	return false;
}

stock GetPlayerArea1(Gplayerid){
	new StringArea[130];
	format(StringArea, sizeof(StringArea), "%s", Zones1[GetPlayerZone1(Gplayerid)][zone_name]);
	return StringArea;
}

stock GetPlayerZone1(Gplayerid){
	new Float:x,Float:y,Float:z;
	GetPlayerPos(Gplayerid,x,y,z);
	for(new i = 0; i < sizeof(Zones1); i++)	{
		if(x > Zones1[i][zone_minx] && y > Zones1[i][zone_miny] && z > Zones1[i][zone_minz] && x < Zones1[i][zone_maxx] && y < Zones1[i][zone_maxy] && z < Zones1[i][zone_maxz])
		return i;
	}
	return false;
}

stock ReturnPlayerID(PlayerName[]) {
	for(new i; i < GetMaxPlayers(); i++)
		if(IsPlayerConnected(i)){
			new name[24];
			GetPlayerName(i,name,24);
			if(strfind(name,PlayerName,true)!=-1)
				return i;
	}
	return INVALID_PLAYER_ID;
}

stock GetPlayerArea(Gplayerid){
	new StringArea[130];
	format(StringArea, sizeof(StringArea), "%s", Zones[GetPlayerZone(Gplayerid)][zone_name]);
	return StringArea;
}

forward AAD_DominarTimer(playerid);
public AAD_DominarTimer(playerid){
if(IsPlayerInCheckpoint(playerid)){
AAD_DominandoINT[playerid]++;
new string[100];
format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~y~Dominando... ~w~%i~y~/~b~20", AAD_DominandoINT[playerid]);
GameTextForPlayer(playerid, string, 3000, 3);
if(AAD_DominandoINT[playerid] >= 20){
AAD_DominandoINT[playerid] = 1;
KillTimer(AAD_DominandoTimer[playerid]);
format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~g~Dominado!", AAD_DominandoINT[playerid]);
GameTextForPlayer(playerid, string, 5000, 3);
AAD_Dominado = 1;
KillTimer(AAD_Timer);
AAD_DefFinalizar();
return 1;}

}else{
AAD_DominandoINT[playerid] = 1;
KillTimer(AAD_DominandoTimer[playerid]);}
return 1;}

/*
forward PL_DominarTimer(playerid);
public PL_DominarTimer(playerid){
if(IsPlayerInCheckpoint(playerid)){
PL_DominandoINT[playerid]++;
new string[200];
format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~y~Roubando... ~w~%i~y~/~r~20", PL_DominandoINT[playerid]);
GameTextForPlayer(playerid, string, 3000, 3);
if(PL_DominandoINT[playerid] >= 20){
PL_DominandoINT[playerid] = 1;
KillTimer(PL_DominandoTimer[playerid]);
KillTimer(PL_Timer);
format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~g~Roubado, Fuja!", PL_DominandoINT[playerid]);
PL_PlayerCD[playerid] = 1;
SendClientMessage(playerid, COLOUR_INFORMACAO, " ");
SendClientMessage(playerid, COLOUR_INFORMACAO, "[PL]: Voce conseguiu roubar, fuja até o ponto de entrega!!");
SendClientMessage(playerid, COLOUR_INFORMACAO, " ");
for(new i; i < GetMaxPlayers(); i++){
	if(IsPlayerConnected(i)) {
		if(PL_Vai[i] == 1 && ArenaTipo[i] == 26) {
			SetPlayerCheckpoint(i, 2839.4961,-2370.1135,31.0078, 2.0);
			PL_Final = 1;
		}
	}
}
PL_Dominado = 1;
PL_DominadoEntregar = false;
KillTimer(PL_Timer);
PL_Timer = SetTimer("PL_DefFinalizar",PL_TIME_DuracaoDaPartida, 0);
return 1;}

}else{
PL_DominandoINT[playerid] = 1;
KillTimer(PL_DominandoTimer[playerid]);}
return 1;}*/

public OnPlayerLeaveCheckpoint(playerid)
{

if(AAD_Team[playerid] == 1 && AAD_EmProgresso == 1 && AAD_Vai[playerid] == 1){
AAD_DominandoINT[playerid] = 1;
KillTimer(AAD_DominandoTimer[playerid]);}

/*
if(PL_Team[playerid] == 1 && PL_EmProgresso == 1 && PL_Vai[playerid] == 1){
PL_DominandoINT[playerid] = 1;
KillTimer(PL_DominandoTimer[playerid]);}*/

return 1;
}

public OnRconCommand(cmd[])
{
new rcmd[100], parametro[100] ,string[128], parametro_int ,idx;
#pragma unused parametro_int
#pragma unused string
rcmd = strtok(cmd, idx);


if(strcmp(rcmd, "fip", true)==0){
parametro = strtok(cmd, idx);
if(!strlen(parametro)) {print("USO: fip <IP>"); return true;}
PesquisarIPRCON(parametro);
return true;}

if(strcmp(rcmd, "id", true)==0){
parametro = strtok(cmd, idx);
if(!strlen(parametro)) {print("USO: id <nick / parte do nick>"); return true;}
PesquisarIDRCON(parametro);
return true;}

return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger){
	if(Nitro(vehicleid)){
		AddVehicleComponent(vehicleid, 1010);
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid){

    if(EAM_EmProgresso == 1 && EAM_Tipo == 0 && PL_Vai[playerid] == 0){
		new string[300];
		new pname[MAX_PLAYER_NAME];
		new quantPlayersOns;

        EAM_QuantPlayer = true;
		EAM_PlayerMorto = false;
		EAM_Player[playerid]=true;
		EAM_Checkpoint[playerid] = true;

		for(new i; i < GetMaxPlayers(); i++){
			if(IsPlayerConnected(i)){
				DisablePlayerCheckpoint(i);
				quantPlayersOns++;
			}
		}
		quantPlayersOns = 20000*quantPlayersOns;
		GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
		format(string, sizeof(string), "[EAM]: EAM iniciou! Matem o player {FFFFFF}%s (%i){FF5A00}, valendo RS%i!", pname, playerid, quantPlayersOns);
		SendClientMessageToAll(COLOUR_EVENTO, string);
		format(string, sizeof(string), "[EAM - DICA]: Usem {FFFFFF}/gps (%i) {21CC21}para localiza-lo!", playerid);
		SendClientMessageToAll(COLOUR_INFORMACAO, string);
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);

		StuntSuperSpeed[playerid] = false;
		EventoProibirTeleEAM[playerid] = true;
		AGps[playerid] = false;

        SendClientMessage(playerid, COLOUR_AVISO, "[EAM]: Voce chegou primeiro! Evite ser morto durante 5 minutos para receber o premio!");
		KillTimer(EAM_Timer);
		EAM_Timer = SetTimer("EAM_DefFinalizar",EAM_TIME_DuracaoDaPartida, 0);
		return 1;
	}

	if(EAM_EmProgresso == 1 && EAM_Tipo == 1 && PL_Vai[playerid] == 0){
		EAM_QuantPlayer = true;
	    new string[300];
	    new quantPlayersOns;

	    for(new i; i < GetMaxPlayers(); i++){
			if(IsPlayerConnected(i)){
				quantPlayersOns++;
				DisablePlayerCheckpoint(i);
  			 }
		}
		quantPlayersOns = 10000*quantPlayersOns;
	    new pname[MAX_PLAYER_NAME];
		GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
		format(string, sizeof(string), "[EAM]: O player {FFFFFF}%s {FF5A00}ganhou R$%i por chegar primeiro ao checkpoint!", pname, quantPlayersOns);
		SendClientMessageToAll(COLOUR_EVENTO, string);
		format(string, sizeof(string), "[EAM]: Voce ganhou R$%i por chegar primeiro! Parabens!!", quantPlayersOns);
		SendClientMessage(playerid, COLOUR_INFORMACAO, string);
        EAM_Player[playerid]=true;
        EventoProibirTeleEAM[playerid] = false;
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		CallRemoteFunction("GivePlayerCash", "ii", playerid, quantPlayersOns);
		return 1;
	}

    if(AAD_Team[playerid] == 2 && AAD_EmProgresso == 1 && AAD_Vai[playerid] == 1){
    SendClientMessage(playerid, COLOUR_AVISO, "[ARENA]: Evite que inimigos dominem este checkpoint! Defenda-o!");
    return 1;}

 	if(AAD_Team[playerid] == 1 && AAD_EmProgresso == 1 && AAD_Vai[playerid] == 1){
    SendClientMessage(playerid, COLOUR_INFORMACAO, "Dominando... Permaneça aqui por 20 segundos para dominar e vencer!");
    AAD_DominandoINT[playerid] = 1;
    AAD_DominandoTimer[playerid] = SetTimerEx("AAD_DominarTimer",1000,1, "i", playerid);
    return 1;}

    if(PL_Team[playerid] == 1 && PL_EmProgresso == 1 && PL_Vai[playerid] == 1 && PL_Final == 0){
        SendClientMessage(playerid, COLOUR_INFORMACAO, " ");
    	SendClientMessage(playerid, COLOUR_INFORMACAO, "[PL]: Evite que inimigos peguem o carro Slamvan!!");
  	 	SendClientMessage(playerid, COLOUR_INFORMACAO, " ");
        PL_DominadoEntregar = false;
        PL_PlayerCD[playerid] = 0;
        return 1;
	}

	if(PL_Team[playerid] == 2 && PL_EmProgresso == 1 && PL_Vai[playerid] == 1 && PL_Final == 0){
        SendClientMessage(playerid, COLOUR_INFORMACAO, " ");
    	SendClientMessage(playerid, COLOUR_INFORMACAO, "[PL]: Pegue a Slamvan e vá até o checkpoint para entregar!!");
  	 	SendClientMessage(playerid, COLOUR_INFORMACAO, " ");
     	new string[300];
	    format(string, sizeof(string), "[PL]: O player {FFFFFF}%s {21CC21}conseguiu pegar a Slamvan, matem-no!!", Nome(playerid));
        SendClientMessageToAll(COLOUR_INFORMACAO, string);
        PL_DominadoEntregar = false;
        PL_PlayerCD[playerid] = 0;
        PL_Final = 1;
		KillTimer(PL_Timer);
        for(new i; i < GetMaxPlayers(); i++){
			if(IsPlayerConnected(i)){
			    if(PL_Vai[playerid] == 1){
					DisablePlayerCheckpoint(i);
				}
			}
		}
		PL_Timer = SetTimer("PL_DefFinalizar",PL_TIME_DuracaoDaPartida, 0);
        return 1;
	}

	if(PL_Team[playerid] == 1 && PL_EmProgresso == 1 && PL_Vai[playerid] == 1 && PL_Final == 1){
    SendClientMessage(playerid, COLOUR_AVISO, "[PL]: Evite que inimigos chega com o carro Slamvan aqui!!");
    return 1;}

	if(PL_Team[playerid] == 2 && PL_EmProgresso == 1 && PL_Vai[playerid] == 1 && PL_Final == 1){
        new modelo = GetVehicleModel(GetPlayerVehicleID(playerid));
		if(modelo == 535){
		    new string[300];
		    format(string, sizeof(string), "[PL]: O player {FFFFFF}%s {21CC21}conseguiu chegar ao checkpoint com o carro Slamvan!!", Nome(playerid));
            SendClientMessageToAll(COLOUR_INFORMACAO, string);
            PL_DominadoEntregar = true;
            PL_PlayerCD[playerid] = 1;
            KillTimer(PL_Timer);
            PL_DefFinalizar();
            return 1;
		}else{
            SendClientMessage(playerid, COLOUR_INFORMACAO, " ");
	    	SendClientMessage(playerid, COLOUR_INFORMACAO, "[PL]: Voce precisa chegar aqui com o carro Slamvan!");
	  	 	SendClientMessage(playerid, COLOUR_INFORMACAO, " ");
	  	 	PL_DominadoEntregar = false;
	  	 	return 1;
		}
	}

 	/*if(PL_Team[playerid] == 2 && PL_EmProgresso == 1 && PL_Vai[playerid] == 1 && PL_Final == 0){
    SendClientMessage(playerid, COLOUR_INFORMACAO, "Roubando... Permaneça aqui por 20 segundos para roubar e fugir!");
    PL_DominandoINT[playerid] = 1;
    PL_DominandoTimer[playerid] = SetTimerEx("PL_DominarTimer",1000,1, "i", playerid);
    return 1;}

	if(PL_Team[playerid] == 2 && PL_EmProgresso == 1 && PL_Vai[playerid] == 1 && PL_Final == 1 && PL_PlayerCD[playerid] == 1){
	    SendClientMessage(playerid, COLOUR_INFORMACAO, " ");
	    SendClientMessage(playerid, COLOUR_INFORMACAO, "[PL]: Voce conseguiu fazer a entrega! Parabens!! ");
	    SendClientMessage(playerid, COLOUR_INFORMACAO, " ");
	    PL_DominandoINT[playerid] = 1;
		PL_DominadoEntregar = true;
		KillTimer(PL_Timer);
	    PL_DefFinalizar();
    return 1;}*/
    
    if(VPlayerMissao[playerid] != 0){if(IsPlayerInAnyVehicle(playerid)){
    DisablePlayerCheckpoint(playerid);
    VPlayerMissao[playerid] = 0;

    if(PlayerMissaoTipo[playerid] == 3){
    if(GetPlayerSpeed(playerid,true) > 20){
    SendClientMessage(playerid, COLOUR_AVISO, "[AVISO]: Missão fracassada! (Passou acima de 20 KM/h)");
    GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~r~MISSAO FRACASSADA!~n~ALTA VELOCIDADE!", 5000, 5);return 1;}}

    switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
	{
	case 403,514,515,525:{
	if(GetVehicleTrailer(GetPlayerVehicleID(playerid)) == 0){
	SendClientMessage(playerid, COLOUR_AVISO, "[AVISO]: Missão fracassada! (Perdeu o reboque)");
	GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~r~MISSAO FRACASSADA!~n~PERDEU O REBOQUE!", 5000, 5);return 1;}}
	}

	new sstring[128];
	format(sstring, sizeof(sstring), "[INFO]: Você ganhou $%i por percorrer %i metros na missão %s", VPlayerMissaoLucro[playerid],VMissaoDistancia[playerid],VMissaoString[playerid]);

	SendClientMessage(playerid, COLOUR_BRANCO," ");
	SendClientMessage(playerid, COLOUR_INFORMACAO,sstring);
	SendClientMessage(playerid, COLOUR_INFORMACAO,"[INFO]: Digite /MIS se deseja fazer outra missão");
	SendClientMessage(playerid, COLOUR_BRANCO," ");
	PlayerPlaySound(playerid,1057,0.0,0.0,0.0);

	new mst2[128];format(mst2, sizeof(mst2), "~n~~n~~n~~n~~n~~n~~g~MISSAO COMPLETA!~n~~y~Lucro: ~w~$%i", VPlayerMissaoLucro[playerid]);
    RepairVehicle(GetPlayerVehicleID(playerid));
    if(GetVehicleTrailer(GetPlayerVehicleID(playerid)) != 0){RepairVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));}
    GameTextForPlayer(playerid,mst2, 5000, 5);
    CallRemoteFunction("GivePlayerCash", "ii", playerid, VPlayerMissaoLucro[playerid]);
    new pname[MAX_PLAYER_NAME],string[128];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
	format(string, sizeof(string), "[INFO]: %s fez uma missão de %s ( /MIS ) ", pname,VMissaoString[playerid]);
	CallRemoteFunction("SaveToFile","ss","Missoes",string);
	SendClientMessageToAllEx(playerid, COLOUR_INFORMACAO, string);}}
    return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
//If player exit he/she's vehicle the xenons added are destroyed
if(Xenon[playerid] == 1){
		if(XenonVerifica[playerid] == 0){
				DestroyObject(Xenons[playerid][0]);
				DestroyObject(Xenons[playerid][1]);
				XenonContagem--;
				XenonContagem--;
		}
		if(XenonVerifica[playerid] == 1){
				DestroyObject(Xenons[playerid][2]);
				DestroyObject(Xenons[playerid][3]);
				XenonContagem--;
				XenonContagem--;
		}
		if(XenonVerifica[playerid] == 2){
				DestroyObject(Xenons[playerid][4]);
				DestroyObject(Xenons[playerid][5]);
				XenonContagem--;
				XenonContagem--;
		}
		if(XenonVerifica[playerid] == 3){
				DestroyObject(Xenons[playerid][6]);
				DestroyObject(Xenons[playerid][7]);
				XenonContagem--;
				XenonContagem--;
		}
		if(XenonVerifica[playerid] == 4){
				DestroyObject(Xenons[playerid][8]);
				DestroyObject(Xenons[playerid][9]);
				DestroyObject(Xenons[playerid][10]);
				DestroyObject(Xenons[playerid][11]);
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
		}
  		if(XenonVerifica[playerid] == 5){
				DestroyObject(Xenons[playerid][12]);
				DestroyObject(Xenons[playerid][13]);
				DestroyObject(Xenons[playerid][14]);
				DestroyObject(Xenons[playerid][15]);
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
		}
		if(XenonVerifica[playerid] == 6){
				DestroyObject(Xenons[playerid][16]);
				DestroyObject(Xenons[playerid][17]);
				DestroyObject(Xenons[playerid][18]);
				DestroyObject(Xenons[playerid][19]);
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
		}
		Xenon[playerid]=0;
}
return 1;
}

forward TimerRapido();
public TimerRapido(){

for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){


if(veiculo[i] != 0 && AutoPaintOn[i] == 1){
ChangeVehicleColor(veiculo[i], PVA(), PVA());}

if(veiculo[i] != 0 && PiscarLuzes[i] == true){
if(PiscarLuzesState[i] == true){
PiscarLuzesState[i] = false;
new engine, lights, alarm, doors, bonnet, boot, objective;
GetVehicleParamsEx(veiculo[i], engine, lights, alarm, doors, bonnet, boot, objective);
SetVehicleParamsEx(veiculo[i], engine, 0, alarm, doors, bonnet, boot, objective);
}else{
PiscarLuzesState[i] = true;
new engine, lights, alarm, doors, bonnet, boot, objective;
GetVehicleParamsEx(veiculo[i], engine, lights, alarm, doors, bonnet, boot, objective);
SetVehicleParamsEx(veiculo[i], engine, 1, alarm, doors, bonnet, boot, objective);}}

}}
return 1;}

stock Float:GetDistanceBetweenPlayers(playerid, Gplayerid)
{
new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
if(!IsPlayerConnected(playerid) || !IsPlayerConnected(Gplayerid)){return -1.00;}
GetPlayerPos(playerid,x1,y1,z1);
GetPlayerPos(Gplayerid,x2,y2,z2);
return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}


forward UnbanIPEx(const IP[]);
public UnbanIPEx(const IP[])
{
new banstr[25];
format(banstr, sizeof(banstr), "unbanip %s", IP);
SendRconCommand(banstr);
return 1;
}

forward FecharSNP2();
public FecharSNP2()
{
KillTimer(TimerSNP2);
SNP2Liberado = false;
return 1;
}




forward RelogKick(playerid);
public RelogKick(playerid)
{
CallRemoteFunction("KickPlayerEx","is",playerid,"Relogando");
return 1;
}





//

public OnPlayerCommandText(playerid, cmdtext[])
{
//XENON
if (strcmp(cmdtext, "/rxenon", true)==0){
	if(Xenon[playerid] == 0) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não possui XENON para remover!");
		if(Xenon[playerid] == 1){
         if(XenonVerifica[playerid] == 0){
				DestroyObject(Xenons[playerid][0]);
				DestroyObject(Xenons[playerid][1]);
				XenonContagem--;
				XenonContagem--;
		}
		if(XenonVerifica[playerid] == 1){
				DestroyObject(Xenons[playerid][2]);
				DestroyObject(Xenons[playerid][3]);
				XenonContagem--;
				XenonContagem--;
		}
		if(XenonVerifica[playerid] == 2){
				DestroyObject(Xenons[playerid][4]);
				DestroyObject(Xenons[playerid][5]);
				XenonContagem--;
				XenonContagem--;
		}
		if(XenonVerifica[playerid] == 3){
				DestroyObject(Xenons[playerid][6]);
				DestroyObject(Xenons[playerid][7]);
				XenonContagem--;
				XenonContagem--;
		}
		if(XenonVerifica[playerid] == 4){
				DestroyObject(Xenons[playerid][8]);
				DestroyObject(Xenons[playerid][9]);
				DestroyObject(Xenons[playerid][10]);
				DestroyObject(Xenons[playerid][11]);
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
		}
  		if(XenonVerifica[playerid] == 5){
				DestroyObject(Xenons[playerid][12]);
				DestroyObject(Xenons[playerid][13]);
				DestroyObject(Xenons[playerid][14]);
				DestroyObject(Xenons[playerid][15]);
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
		}
		if(XenonVerifica[playerid] == 6){
				DestroyObject(Xenons[playerid][16]);
				DestroyObject(Xenons[playerid][17]);
				DestroyObject(Xenons[playerid][18]);
				DestroyObject(Xenons[playerid][19]);
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
		}
			Xenon[playerid]=0;
			GameTextForPlayer(playerid,"~w~~h~~h~XENON REMOVIDO COM SUCESSO",2000,3);
		}
return 1;
}

if (strcmp(cmdtext, "/xenon", true)==0){
	if(GetPlayerState(playerid)==PLAYER_STATE_DRIVER){
		if(!IsPlayerInAnyVehicle(playerid))return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você precisa de um carro!");
		if(IsPlayerOnBike(playerid)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não pode colocar XENON na moto!");
		if(IsPlayerOnHeli(playerid)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não pode colocar XENON no helicoptero!");
		if(IsPlayerOnPlane(playerid)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não pode colocar XENON no avião!");
		if(IsPlayerInBoat(playerid)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não pode colocar XENON no barco!");
		if(IsPlayerOnBicycle(playerid)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não pode colocar XENON na bicileta!");
		if(IsPlayerOnRC(playerid)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não pode colocar XENON em um veiculo RC!");
		if(XenonContagem < 20){
			SendPlayerFormattedText(playerid, COLOUR_INFORMACAO, "[INFO]: Escolha seu XENON na lista. {C0C0C0}[Veículos com XENON: %i de 10]", XenonContagem/2);
			ShowPlayerDialog(playerid, XenonDialog, DIALOG_STYLE_LIST, "{00FFEB}Escolha a cor do XENON:", "{0000FF}Azul\n{2DB61B}Verde\n{FFFFFF}Branco\n{FF0000}Vermelho\n{F6FF00}Amarelo\n{FF00EE}Rosa\n{70FFD7}Verde Claro\n{B0B0B0}Remover Xenon", "Adicionar", "Cancelar");
		}else{
			SendClientMessage(playerid, COLOUR_AVISO, "[AVISO]: Todas as 10 vagas para neon estão ocupadas no momento");
		}
  		}else return SendClientMessage(playerid,RedColor,"[ERRO]: Você não é o condutor de um veículo!");
return 1;
}

if(GetPVarInt(playerid,"InMaze") & strcmp(cmdtext, "/sairlb", true) != 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Comandos bloqueados por estar no Labirinto!");
if(strcmp(cmdtext, "/sairlb", true) == 0) {

  		if(GetPVarInt(playerid,"InMaze") == 1)	{
		SetPVarInt(playerid,"InMaze",0);
		SpawnPlayer(playerid);
		}
	return 1;
}

new cmd[128];
new idx;
new tmp[128];
new string[128];
cmd = strtok(cmdtext, idx);

if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2){
if(preso[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não pode usar comandos na cadeia!");}

if(VPlayerMissao[playerid] != 0){new mst1[128],mst2[128];
format(mst1, sizeof(mst1), "Sua missão: %s", VMissaoString[playerid]);
format(mst2, sizeof(mst2), "Destino: %s - Lucro: $%i - Distancia: %i metros",VMissaoDestinoTXT[playerid],VPlayerMissaoLucro[playerid],VMissaoDistancia[playerid]);
SendClientMessage(playerid, COLOUR_BRANCO,"");
SendClientMessage(playerid, COLOUR_INFORMACAO,mst1);
SendClientMessage(playerid, COLOUR_INFORMACAO,mst2);
SendClientMessage(playerid, COLOUR_AVISO, "Você não pode usar comandos em uma missão!");
SendClientMessage(playerid, COLOUR_AVISO, "Para cancelar a missão, saia do veículo");
SendClientMessage(playerid, COLOUR_BRANCO,"");return 1;}

/*dcmd(ga,2,cmdtext);
dcmd(membros,7,cmdtext);*/
dcmd(enquete,7,cmdtext);
dcmd(sim,3,cmdtext);
dcmd(nao,3,cmdtext);
dcmd(aceitar,7,cmdtext);
dcmd(pvcescolher,11,cmdtext);
dcmd(eamescolher,11,cmdtext);
dcmd(id,2,cmdtext);
dcmd(tpick,4,cmdtext);
dcmd(svname,6,cmdtext);
dcmd(velocidade,10,cmdtext);
dcmd(rmwanted,8,cmdtext);
dcmd(tela2,5,cmdtext);
dcmd(notificar,9,cmdtext);
dcmd(hmc,3,cmdtext);
//dcmd(ganghmc,7,cmdtext);
dcmd(kcor,4,cmdtext);
dcmd(kmae,4,cmdtext);
dcmd(placa,5,cmdtext);
dcmd(sortear,7,cmdtext);
dcmd(sortearscore,12,cmdtext);
dcmd(dsss,4,cmdtext);
dcmd(inativo,7,cmdtext);
dcmd(granafacil,10,cmdtext);
dcmd(adm,3,cmdtext);
dcmd(grupo,5,cmdtext);
dcmd(testarsom,9,cmdtext);
dcmd(tocarsom,8,cmdtext);
dcmd(tocarmusica,11,cmdtext);
dcmd(tela3,5,cmdtext);
dcmd(gps,3,cmdtext);
dcmd(pmadm,5,cmdtext);
dcmd(abann,5,cmdtext);
dcmd(akick,5,cmdtext);
dcmd(aban,4,cmdtext);
dcmd(eventotela,10,cmdtext);
dcmd(bugar,5,cmdtext);
dcmd(x1c,3,cmdtext);
dcmd(fip,3,cmdtext);
dcmd(setsvfull,9,cmdtext);
dcmd(setsvfullminutes,16,cmdtext);
dcmd(minharadio,10,cmdtext);
dcmd(verlog,6,cmdtext);
dcmd(findban,7,cmdtext);
dcmd(eventonome,10,cmdtext);

if(strcmp("/notpiscar", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,0x66CCFFAA,StringTable[8]);
if(NotificarBlinking == false){
NotificarBlinking = true;
KillTimer(TimerNotBlinker);
TimerNotBlinker = SetTimer("NotificarBlink",250, 1);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Notificar piscando");
}else{
NotificarBlinking = false;
KillTimer(TimerNotBlinker);
TextDrawShowForAll(TxDNotificador);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Notificar estático");}
return 1;}

if(strcmp("/ponto", cmd, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,0x66CCFFAA,StringTable[8]);
new params[100];
params = strtok(cmdtext, idx);
if(!strlen(params)) return SendClientMessage(playerid,COLOUR_ERRO,"USO: /ponto [ir/salvar/distancia/tele]");
if(strcmp(params, "IR", true) == 0){
if(PontoU[playerid] == false) return SendClientMessage(playerid,0x66CCFFAA,"[ERRO]: Você precisa marcar um ponto temporário antes: {FFFFFF}/ponto salvar");
new distancia = DistanciaAtePonto(playerid, PontoX[playerid], PontoY[playerid], PontoZ[playerid]);
SetPlayerInterior(playerid,PontoI[playerid]);
SetPlayerVirtualWorld(playerid,PontoW[playerid]);
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),PontoX[playerid], PontoY[playerid], PontoZ[playerid]+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid), PontoF[playerid]);
}else{
SetPlayerPos(playerid,PontoX[playerid], PontoY[playerid], PontoZ[playerid]);
SetPlayerFacingAngle(playerid,PontoF[playerid]);
SetCameraBehindPlayer(playerid);}
format(string, sizeof(string), "[INFO]: Você foi teleportado ao ponto salvo - Distância: {FFFFFF}%i metros", distancia);
SendClientMessage(playerid, COLOUR_INFORMACAO, string);
return 1;}
if(strcmp(params, "DISTANCIA", true) == 0 || strcmp(params, "MEDIR", true) == 0){
if(PontoU[playerid] == false) return SendClientMessage(playerid,0x66CCFFAA,"[ERRO]: Você precisa marcar um ponto temporário antes: {FFFFFF}/ponto salvar");
new distancia = DistanciaAtePonto(playerid, PontoX[playerid], PontoY[playerid], PontoZ[playerid]);
format(string, sizeof(string), "[INFO]: Distância até o ponto marcado: {FFFFFF}%i metros", distancia);
SendClientMessage(playerid, COLOUR_INFORMACAO, string);
return 1;}
if(strcmp(params, "MARCAR", true) == 0 || strcmp(params, "SALVAR", true) == 0){
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Por favor, desça do carro antes de salvar um ponto!");
PontoAT[playerid] = false;
PontoU[playerid] = true;
PontoI[playerid] = GetPlayerInterior(playerid);
PontoW[playerid] = GetPlayerVirtualWorld(playerid);
GetPlayerFacingAngle(playerid, PontoF[playerid]);
GetPlayerPos(playerid, PontoX[playerid], PontoY[playerid], PontoZ[playerid]);
format(string, sizeof(string), "[INFO]: Ponto temporário marcado - Será memorizado somente durante essa sessão");
SendClientMessage(playerid, COLOUR_INFORMACAO, string);
return 1;}
if(strcmp(params, "TELE", true) == 0){
if(PontoU[playerid] == false) return SendClientMessage(playerid,0x66CCFFAA,"[ERRO]: Você precisa marcar um ponto temporário antes: {FFFFFF}/ponto salvar");
if(PontoAT[playerid] == false){
PontoAT[playerid] = true;
format(string, sizeof(string), "[INFO]: Os players poderão teleportar para seu ponto usando: {FFFFFF}/teleponto %i", playerid);
}else{
format(string, sizeof(string), "[INFO]: Os players não poderão teleportar para seu ponto");
PontoAT[playerid] = false;}
SendClientMessage(playerid, COLOUR_INFORMACAO, string);
return 1;}
SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Parâmetro inexistente!");
return 1;}

if(strcmp(cmd, "/teleponto", true)==0){
new parametro[100],parametro_int;
parametro = strtok(cmdtext, idx);
parametro_int = strval(parametro);
if(!strlen(parametro)) return SendClientMessage(playerid,COLOUR_ERRO,"USO: /teleponto <id>");
if(!IsNumeric(parametro)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: ID Inválida");
if(!IsPlayerConnected(parametro_int)) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[10]);
if(PontoU[parametro_int] == false || PontoAT[parametro_int] == false) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: O player mencionado não criou ponto de teleporte");
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
new admname[MAX_PLAYER_NAME];GetPlayerName(parametro_int, admname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o teleporte de {FF387A}%s {FFFB00}( /teleponto %i )", pname, admname, parametro_int);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,PontoI[parametro_int]);
SetPlayerVirtualWorld(playerid,PontoW[parametro_int]);
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),PontoX[parametro_int], PontoY[parametro_int], PontoZ[parametro_int]+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid), PontoF[parametro_int]);}else{
SetPlayerPos(playerid,PontoX[parametro_int], PontoY[parametro_int], PontoZ[parametro_int]);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,PontoF[parametro_int]);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/delcar", true)==0){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,0x66CCFFAA,StringTable[8]);
new parametro[100],parametro_int;
parametro = strtok(cmdtext, idx);
parametro_int = strval(parametro);
if(!strlen(parametro)) return SendClientMessage(playerid,COLOUR_ERRO,"USO: /delcar <id>");
if(!IsNumeric(parametro)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: ID Inválida");
if(!IsPlayerConnected(parametro_int)) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[10]);
if(veiculo[parametro_int] == 0) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Jogador não criou veículos ainda");
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"DELCAR");
new pname[MAX_PLAYER_NAME], admname[MAX_PLAYER_NAME];
GetPlayerName(parametro_int, pname, MAX_PLAYER_NAME);
GetPlayerName(playerid, admname, MAX_PLAYER_NAME);
new MsgToADM[100], MsgToPlayer[100];
format(MsgToADM, sizeof(MsgToADM), "[INFO]: O veículo de %s (%i) foi removido com sucesso!", pname, parametro_int);
format(MsgToPlayer, sizeof(MsgToPlayer), "[INFO]: Administrador %s (%i) destruiu seu veículo!", pname, playerid);
if(veiculo[parametro_int] != 0){DestroyVehicle(veiculo[parametro_int]);vtrancado[veiculo[parametro_int]] = 0;veiculo[parametro_int] = 0;}
SendClientMessage(playerid, COLOUR_INFORMACAO, MsgToADM);
SendClientMessage(parametro_int, COLOUR_INFORMACAO, MsgToPlayer);
return 1;}

if(strcmp(cmd, "/loglines", true)==0){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,0x66CCFFAA,StringTable[8]);
if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
new parametro[100],parametro_int;
parametro = strtok(cmdtext, idx);
parametro_int = strval(parametro);
if(!strlen(parametro)) return SendClientMessage(playerid,COLOUR_ERRO,"USO: /loglines <linhas>");
if(!IsNumeric(parametro)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Linhas inválidas");
if(parametro_int > 100) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Digite um valor até 100 linhas");
if(parametro_int < 1) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Digite um valor com pelo menos 1 linha");
ShowLogLines[playerid] = parametro_int;
new MsgToADM[100];
format(MsgToADM, sizeof(MsgToADM), "[INFO]: Linhas de LOG que serão exibidas para você usando /verlog: {FFFFFF}%i", ShowLogLines[playerid]);
SendClientMessage(playerid, COLOUR_INFORMACAO, MsgToADM);
return 1;}

if(strcmp("/unbanlip", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 3) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[8]);
if(strlen(LastIPBannedLIP) < 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Nenhum IP foi banido pelo /banlip");
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"UNBANLIP");
new strkw[100],banstr[25];
format(banstr, sizeof(banstr), "unbanip %s", LastIPBannedLIP);
format(strkw, sizeof(strkw), "[INFO]: O IP %s banido pelo /banlip foi desbanido com sucesso!", LastIPBannedLIP);
format(LastIPBannedLIP, sizeof(LastIPBannedLIP), "");
SendRconCommand(banstr);
SendClientMessage(playerid, COLOUR_INFORMACAO, strkw);
return 1;}

if(strcmp("/banlip", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 3) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[8]);
if(TickCounter - BanLipTick <= 5) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O /banlip só pode ser usado uma vez a cada 5 segundos");
BanLipTick = TickCounter;
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"BANLIP");
new strkw[100];
SendClientMessage(playerid, COLOUR_CINZA, "[INFO]: BANLIP = Bane o último IP que se conectou no servidor - (Desfazer: /unbanlip)");
new banstr[25],bannedplayername[MAX_PLAYER_NAME],pname[MAX_PLAYER_NAME];
format(banstr, sizeof(banstr), "banip %s", LastIPConnected);
LastIPBannedLIP = LastIPConnected;
for(new i; i < GetMaxPlayers(); i++)
{
	if(IsPlayerConnected(i))
	{
		if(strcmp(LastIPConnected, PlayerIp(i), true) == 0)
		{
		GetPlayerName(i, pname, MAX_PLAYER_NAME);
		format(bannedplayername, sizeof(bannedplayername), "%s", pname);
		break;
		}
	}
}
SendRconCommand(banstr);
if(strlen(bannedplayername) < 1) bannedplayername = "<<PLAYER OFFLINE>>";
format(strkw, sizeof(strkw), "[INFO]: O IP %s associado ao player %s foi banido com sucesso!", LastIPConnected, bannedplayername);
CallRemoteFunction("SaveToFile","ss","BanLIP",strkw);
SendClientMessage(playerid, COLOUR_INFORMACAO, strkw);
return 1;}


if(strcmp("/kw", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[8]);
if(GetMaxPlayers() - ConnectedPlayers() > 3) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: O servidor não está cheio. Cheio = faltando 3 slots p/ limite");
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"KW");
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Procurando e kickando players inativos...");
for(new i; i < GetMaxPlayers(); i++)
{
	if(IsPlayerConnected(i))
	{
		if(AwaySeconds[i] >= SvFullValueMinutes*60)
		{
		    if(CallRemoteFunction("GetPlayerAdminLevel","i",i) < 1)
		    {
		    new strkw[100];
		    format(strkw, sizeof(strkw), "Inativo há mais de %i minutos com o servidor cheio", SvFullValueMinutes);
			CallRemoteFunction("KickPlayerEx","is",i,strkw);
			}
	    }
  	}
}
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Limpeza de players inativos efetuada com sucesso!");
return 1;}


if(strcmp("/radar", cmdtext, true) == 0) {

if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2)
{
if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Para usar o radar você deve estar em uma aeronave ou veículo de combate!");
if(!IsACombatVehicle(GetPlayerVehicleID(playerid))) return SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Para usar o radar você deve estar em uma aeronave ou veículo de combate!");
}

new str[200];
new modelo;
new Float:Distancia;
new pname[MAX_PLAYER_NAME];
new Detects;

SendClientMessage(playerid, COLOUR_INFORMACAO, "======================== RADAR DE COMBATE =====================");

for(new i; i < GetMaxPlayers(); i++)
{
	if(IsPlayerConnected(i))
	{
	    if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
	    {
	        if(IsACombatVehicle(GetPlayerVehicleID(i)))
	        {
	        	if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid))
	        	{
	        		if(playerid != i)
	        		{
	        		modelo = GetVehicleModel(GetPlayerVehicleID(i));
	        		Distancia = GetDistanceBetweenPlayers(playerid, i);
	        		GetPlayerName(i, pname, sizeof(pname));
	       	    	format(str, sizeof(str), "{00FF8C}Objeto: {FFFFFF}%s {00FF8C}  Player: {FFFFFF}%s (%i) {00FF8C}  Distância: {FFFFFF}%0.0f metros", VehicleNames[modelo-400], pname, i, Distancia);
	        		SendClientMessage(playerid, COLOUR_INFORMACAO, str);
            		Detects++;
            		}
          	    }
	        }
	    }
	}
}

if(Detects == 0) SendClientMessage(playerid, COLOUR_INFORMACAO, "Não foram detectados veículos ou aeronaves de combate em atividade");

SendClientMessage(playerid, COLOUR_INFORMACAO, "===============================================================");
return 1;}

if(strcmp("/ppl", cmdtext, true) == 0 || strcmp("/pss", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[8]);
new str[200];
new pname[MAX_PLAYER_NAME];
new Detects;
SendClientMessage(playerid, COLOUR_INFORMACAO, "============== POSSÍVEIS SPEEDHACKS ===========");

for(new i; i < GetMaxPlayers(); i++)
{
	if(IsPlayerConnected(i))
	{
	    if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
	    {
    		if(StuntSuperSpeed[i] == false)
	        {
	        	if(GetPlayerSpeed2D(i,true) > 290)
	        	{
				GetPlayerName(i, pname, sizeof(pname));
	       	   	format(str, sizeof(str), "{FF0000}Velocidade: {FFFFFF}%i KM/h {FF0000}  Player: {FFFFFF}%s (%i)", GetPlayerSpeed2D(i,true), pname, i);
	        	SendClientMessage(playerid, COLOUR_INFORMACAO, str);
            	Detects++;
            	}
       	  	}
	    }
	}
}
if(Detects == 0) SendClientMessage(playerid, COLOUR_INFORMACAO, "Não foram detectados players acima de 290 KM/h");
SendClientMessage(playerid, COLOUR_INFORMACAO, "===============================================");
return 1;}

if(strcmp(cmdtext, "/agps", true) == 0) {
	if(!IsPlayerSpawned(playerid)){return 1;}
	if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
	if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
	if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
	if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
	if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
	if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
	if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar AGPS no EAM!");

	if(AGps[playerid] == false){
		if(CallRemoteFunction("GetPlayerCash", "i", playerid) >= 15000){
			CallRemoteFunction("GivePlayerCash", "ii", playerid, -15000);
			AGps[playerid] = true;
			SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você está com Anti-GPS, isso custou $15000");
		}else{
			SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Dinheiro insuficiente para Anti-GPS");
		}
	}else{
		AGps[playerid] = false;
		SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Anti-GPS desativado");
	}
	return 1;
}

if(strcmp("/gx1", cmdtext, true) == 0) {
//Inicializa
if(!IsPlayerSpawned(playerid)){return 1;}
if(Anova == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Esta arena foi temporariamente desativada para manutenção");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
new oponenteid = ChamadoParaX1Por[playerid];
new Tx1 = CX1Tipo[playerid];
if(oponenteid == playerid) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não pode disputar um X1 contra sua sombra!");
if(oponenteid == -1) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Ninguém te convidou para um X1 ou o convite foi cancelado");
//Valida oponente
if(!IsPlayerSpawned(oponenteid)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Seu oponente não nasceu ainda!");
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(EventoProibirTele == true && NoEvento[oponenteid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Seu oponente está dentro de um evento");
if(GetPlayerInterior(oponenteid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Seu oponente deve sair do interior");
if(Arena[oponenteid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Seu oponente já está em uma arena!");
if(LifeBaixo(oponenteid)) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Seu oponente está com pouca vida!");
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",oponenteid) && GetPlayerInterior(oponenteid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Seu oponente está em um local em que os teleportes são bloqueados");
//Valida playerid
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);

//Prepara sistema - verificações finais
if(Tx1 == 0) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Houve um erro interno no gamemode! Para evitar bugs o X1 não irá ocorrer...");
//Prepara Arena
new X1CWorld = 11000+oponenteid;
for(new i; i < GetMaxPlayers(); i++)
{
	if(IsPlayerConnected(i))
	{
		if(GetPlayerVirtualWorld(i) == X1CWorld && IsPlayerSpawned(i))
		{
		SetPlayerHealth(i,0.0);
		SendClientMessage(i,COLOUR_AVISO,"[AVISO]: Você foi morto por estar em uma arena/world de X1 que será usada agora");
        }
	}
}


//Prepara player
ResetAwayStatus(playerid);
RemoverTodosAttachsObj(playerid);
SetPlayerVirtualWorld(playerid, X1CWorld);
SetPlayerInterior(playerid,1);
SetPlayerPos(playerid, 1391.8967,-26.4308,1009.0000); // Warp the player
SetCameraBehindPlayer(playerid);
ResetPlayerWeapons(playerid);


//X1 Running
if(Tx1 == 1){
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,100);
GivePlayerWeapon(playerid, 22, 9999);
GivePlayerWeapon(playerid, 28, 9999);
GivePlayerWeapon(playerid, 26, 9999);
GameTextForPlayer(playerid,"~r~X1! MANDA VER!", 3000, 5);
ArenaTipo[playerid] = 13;
Arena[playerid] = 1;}

//X1 Walking
if(Tx1 == 2){
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,100);
GivePlayerWeapon(playerid, 4, 2);
GivePlayerWeapon(playerid, 24, 9999);
GivePlayerWeapon(playerid, 25, 9999);
GivePlayerWeapon(playerid, 31, 9999);
GivePlayerWeapon(playerid, 34, 9999);
GivePlayerWeapon(playerid, 29, 9999);
GameTextForPlayer(playerid,"~r~X1 WALK! MANDA VER!", 3000, 5);
ArenaTipo[playerid] = 14;
Arena[playerid] = 1;
}

//Prepara oponente
ResetAwayStatus(oponenteid);
RemoverTodosAttachsObj(oponenteid);
SetPlayerVirtualWorld(oponenteid, X1CWorld);
SetPlayerInterior(oponenteid,1);
SetPlayerPos(oponenteid, 1391.8967,-26.4308,1009.0000); // Warp the player
SetCameraBehindPlayer(oponenteid);
ResetPlayerWeapons(oponenteid);

//X1 Running
if(Tx1 == 1){
SetPlayerHealth(oponenteid,100);
SetPlayerArmour(oponenteid,100);
GivePlayerWeapon(oponenteid, 22, 9999);
GivePlayerWeapon(oponenteid, 28, 9999);
GivePlayerWeapon(oponenteid, 26, 9999);
GameTextForPlayer(oponenteid,"~r~X1! MANDA VER!", 3000, 5);
ArenaTipo[oponenteid] = 13;
Arena[oponenteid] = 1;}

//X1 Walking
if(Tx1 == 2){
SetPlayerHealth(oponenteid,100);
SetPlayerArmour(oponenteid,100);
GivePlayerWeapon(oponenteid, 4, 2);
GivePlayerWeapon(oponenteid, 24, 9999);
GivePlayerWeapon(oponenteid, 25, 9999);
GivePlayerWeapon(oponenteid, 31, 9999);
GivePlayerWeapon(oponenteid, 34, 9999);
GivePlayerWeapon(oponenteid, 29, 9999);
GameTextForPlayer(oponenteid,"~r~X1 WALK! MANDA VER!", 3000, 5);
ArenaTipo[oponenteid] = 14;
Arena[oponenteid] = 1;
}

//Finalizar
new pname[MAX_PLAYER_NAME],pname2[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, sizeof(pname));
GetPlayerName(oponenteid, pname2, sizeof(pname2));
new str[160];
new X1TipoSTR[20];
if(Tx1 == 1) X1TipoSTR = "RUNNING";
if(Tx1 == 2) X1TipoSTR = "WALKING";

//CX1Tipo[param]
format(str, sizeof(str), "[X1]: Começou um X1 {00FFFF}%s{00FF00}: {FFFFFF}%s {00FF00}contra{FFFFFF} %s", X1TipoSTR, pname, pname2);
SendClientMessageToAll(COLOUR_INFORMACAO, str);
return 1;}

if(strcmp("/afk", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(AFK[playerid] == false){
AFK[playerid] = true;
SetPlayerVirtualWorld(playerid, 2000000+playerid);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você está no modo AFK - Não bugará com downloads!");
}else{
AFK[playerid] = false;
SetPlayerVirtualWorld(playerid, 0);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você está no modo normal agora!");}
return 1;}

if(strcmp("/grupoons", cmdtext, true) == 0) {
if(GetPVarInt(playerid,"GrupoChat") == 0) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não está em nenhum grupo de chat");
new OnNoGrupo;
for(new i; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i))
if(GetPVarInt(playerid,"GrupoChat") == GetPVarInt(i,"GrupoChat")) OnNoGrupo++;
format(string, sizeof(string), "[GRUPO]: Players online no grupo %i: {FFFFFF}%i", GetPVarInt(playerid,"GrupoChat"),OnNoGrupo);
SendClientMessage(playerid, COLOUR_INFORMACAO, string);
return 1;}

if(strcmp("/ouvintes", cmdtext, true) == 0) {
new Ouvintes;
for(new i; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i))
if(OuvindoRadio[i] == true) Ouvintes++;
format(string, sizeof(string), "[INFO]: Players ouvindo rádios online: {FFFFFF}%i", Ouvintes);
SendClientMessage(playerid, COLOUR_INFORMACAO, string);
return 1;}

if(strcmp("/eventoons", cmdtext, true) == 0) {
if(EventoAtivo != 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Sem eventos no momento");
new EventoONS;
for(new i; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i))
if(NoEvento[i] == 1 && EventoAtivo == 1) EventoONS++;
format(string, sizeof(string), "[EVENTO]: Players online no evento: {FFFFFF}%i", EventoONS);
SendClientMessage(playerid, COLOUR_INFORMACAO, string);
return 1;}

if(strcmp("/radio", cmdtext, true) == 0 || strcmp("/radios", cmdtext, true) == 0) {
ShowRadiosForPlayer(playerid);
return 1;}

if(strcmp("/off", cmdtext, true) == 0) {
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: A reprodução de rádios ou sons web foi parada");
    StopAudioStreamForPlayer(playerid);
	return 1;
}

if(strcmp("/sairgrupo", cmdtext, true) == 0 || strcmp("/gruposair", cmdtext, true) == 0) {
if(GetPVarInt(playerid,"GrupoChat") == 0) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não está em nenhum grupo de chat");
format(string, sizeof(string), "[GRUPO]: Você saiu do grupo: {FFFFFF}%i", GetPVarInt(playerid,"GrupoChat"));
SetPVarInt(playerid, "GrupoChat", 0);
SendClientMessage(playerid, COLOUR_INFORMACAO, string);
return 1;}
/*
if(strcmp("/clacriar", cmdtext, true) == 0) {
	if(!IsPlayerSpawned(playerid)){return 1;}
	if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
	if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode criar um cla agora!");
	if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
	if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
	if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
	if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
	if(PlayerDados[playerid][Lider] > 0 || PlayerDados[playerid][Membro] > 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você ja é de um cla, use {FFFFFF}/clasair {FF0000}para sair dela");
	ShowPlayerDialog(playerid, DIALOG_CRIAR, DIALOG_STYLE_INPUT, "{22750B}Criando um cla", "{3BE60B}Escreva abaixo o Nome do\nCla que você deseja criar", "Criar", "Cancelar");
	return 1;
}

if(strcmp("/infocla", cmdtext, true) == 0) {
    new String[300];
    if(PlayerDados[playerid][Membro] == 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não pertence a nenhum cla!");
	if(PlayerDados[playerid][Lider] == 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não é lider de um cla!");
 	if(!IsPlayerSpawned(playerid)){return 1;}
	if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
	if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode criar um cla agora!");
	if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
	if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
	if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
	if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
	
	format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
	format(String, sizeof(String), "{0DD0DE}Menu da Gang %s", DOF2_GetString(String, "Nome"));
	ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_LIST, String,"{FFFFFF}Nome do Cla\n{FFFFFF}Skin do Cla\n{FFFFFF}Convidar\n{FFFFFF}Promover\n{FFFFFF}Spawn\n{FFFFFF}Cor\n{FF0000}Demitir\n{FF0000}Encerrar Cla", "Ver", "Cancelar");
	return 1;
}

if(strcmp("/clasair", cmdtext, true) == 0) {
	if(PlayerDados[playerid][Lider] > 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você é lider de um Cla, para encerra-la use {FFFFFF}/INFOCLA!");
	if(PlayerDados[playerid][Membro] == 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não faz parte de nenhum CLA!");
	PlayerDados[playerid][Membro] = 0;
	SendClientMessage(playerid, COLOUR_INFORMACAOGANG, "[CLA]: Você saiu do CLA!");
	return 1;
}*/

if(strcmp("/sssplayers", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 1) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
new pname[MAX_PLAYER_NAME];new str[100],cc;
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){
if(StuntSuperSpeed[i] == true){
GetPlayerName(i, pname, MAX_PLAYER_NAME);
format(str, sizeof(string), "%s (%i) - com Stunt Super Speed", pname,i);
SendClientMessage(playerid, COLOUR_INFORMACAO, str);cc++;}}}
if(cc == 0) return SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Nenhum player está com Stunt Super Speed");
return 1;}

if(strcmp("/sssadm", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(StuntSuperSpeed[playerid] == false){
StuntSuperSpeed[playerid] = true;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Stunt Super Speed ativado para você!");
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO:] Para usar os poderes, use o clique direito do mouse e a tecla CTRL! (Em um veículo)");
}else{
StuntSuperSpeed[playerid] = false;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Stunt Super Speed desativado para você!");}
return 1;}

if(strcmp("/speed", cmdtext, true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(Derby[playerid] != 0) return SendClientMessage(playerid,COLOUR_ERRO, "[ERRO]: Voce não pode comprar SPEED na arena DERBY!");
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode pega /SPEED no evento EAM!");
if(NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não pode comprar SPEED no evento!");
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
if(StuntSuperSpeed[playerid] == false){
	new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
	format(string, sizeof(string), "{FF0000}%s {FFFFFF}pegou SPEED gratis{FF0000} ( /SPEED )", pname);
	SendClientMessageToAll(COLOUR_AVISO, string);
	ProgramarAntiFlood(playerid);
	StuntSuperSpeed[playerid] = true;
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]:  {FF0000}Stunt Super Speed ativado para você!");
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]:  {FF0000}Para usar os poderes, use o clique direito do mouse e a tecla CTRL! (Em um veículo)");

}else{
   	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]:  {FF0000}Stunt Super Speed desativado para você!");
   	StuntSuperSpeed[playerid] = false;
}

return 1;}


if(strcmp("/ncplayers", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
new pname[MAX_PLAYER_NAME];new str[100],cc;
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){
if(NascerComColete[i] == true){
GetPlayerName(i, pname, MAX_PLAYER_NAME);
format(str, sizeof(string), "%s (%i) - Nascendo com colete", pname,i);
SendClientMessage(playerid, COLOUR_INFORMACAO, str);cc++;}

if(NascerComKw[i] == true){
GetPlayerName(i, pname, MAX_PLAYER_NAME);
format(str, sizeof(string), "%s (%i) - Nascendo com Kit Walk", pname,i);
SendClientMessage(playerid, COLOUR_INFORMACAO, str);cc++;}

if(NascerComKr[i] == true){
GetPlayerName(i, pname, MAX_PLAYER_NAME);
format(str, sizeof(string), "%s (%i) - Nascendo com Kit Run", pname,i);
SendClientMessage(playerid, COLOUR_INFORMACAO, str);cc++;}

if(NascerComTp[i] == true){
GetPlayerName(i, pname, MAX_PLAYER_NAME);
format(str, sizeof(string), "%s (%i) - Nascendo com Kit Top", pname,i);
SendClientMessage(playerid, COLOUR_INFORMACAO, str);cc++;}

if(NascerComKitGuerra[i] == true){
GetPlayerName(i, pname, MAX_PLAYER_NAME);
format(str, sizeof(string), "%s (%i) - Nascendo com Kit Guerra", pname,i);
SendClientMessage(playerid, COLOUR_INFORMACAO, str);cc++;}}}
if(cc == 0) return SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Nenhum player está nascendo com algum kit");
return 1;}

if(strcmp("/hdc", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"HDC");
CriarHydraGM();
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Hydra criado!");
return 1;}

if(strcmp("/hdd", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"HDD");
DestruirHydraGM();
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Hydra destruído!");
return 1;}

if(strcmp("/hdr", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"HDR");
RespawnHydraGM();
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Hydra respawnado!");
return 1;}

if(strcmp("/hder", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"HDER");
DerrubarHydraGM();
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Hydra derrubado!");
return 1;}

if(strcmp("/ssc", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"SSC");
CriarSeaspGM();
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Seasparrow criado!");
return 1;}

if(strcmp("/ssd", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"SSD");
DestruirSeaspGM();
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Seasparrow destruído!");
return 1;}

if(strcmp("/ssr", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"SSR");
RespawnSeaspGM();
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Seasparrow respawnado!");
return 1;}

if(strcmp("/sser", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"SSER");
DerrubarSeaspGM();
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Seasparrow derrubado!");
return 1;}

if(strcmp("/svconfig", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Salvando configurações do GM...");
SaveConfig();
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Configurações salvas com sucesso!");
return 1;}

if(strcmp(cmd, "/meufps", true) == 0 || strcmp(cmd, "/fps", true) == 0) {
new FPS = GetPVarInt(playerid,"PVarFPS");
new PING = GetPlayerPing(playerid);
new avalPING[11];
if(PING < 150) avalPING = "Excelente";
if(PING >= 150) avalPING = "Muito boa";
if(PING >= 200) avalPING = "Boa";
if(PING >= 220) avalPING = "Normal";
if(PING >= 300) avalPING = "Ruim";
if(PING >= 350) avalPING = "Péssima";
new avalFPS[13];
if(FPS == 0) avalFPS = "Indisponível";
if(FPS > 0) avalFPS = "Péssimo";
if(FPS >= 15) avalFPS = "Ruim";
if(FPS >= 24) avalFPS = "Normal";
if(FPS >= 35) avalFPS = "Bom";
if(FPS >= 40) avalFPS = "Muito bom";
if(FPS >= 50) avalFPS = "Excelente";
new string2[100];
format(string, sizeof(string), "Seu FPS: %i - Seu PING: %i", FPS,PING);
format(string2, sizeof(string2), "Seu computador: %s - Sua conexão: %s", avalFPS,avalPING);
if(MostrandoFPSPing[playerid] == false) MostrandoFPSPing[playerid] = true; else MostrandoFPSPing[playerid] = false;
SendClientMessage(playerid, COLOUR_INFORMACAO, string);
SendClientMessage(playerid, COLOUR_INFORMACAO, string2);
return 1;}

if(strcmp(cmd, "/velocimetro", true) == 0) {
if(MostrandoVelocimetro[playerid] == 0){
MostrandoVelocimetro[playerid] = 1;
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || PLAYER_STATE_PASSENGER){
TextDrawShowForPlayer(playerid,TXTVELOCIDADE[playerid]);}
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Velocímetro ativado");
}else{
MostrandoVelocimetro[playerid] = 0;
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || PLAYER_STATE_PASSENGER){
TextDrawHideForPlayer(playerid,TXTVELOCIDADE[playerid]);}
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Velocímetro desativado");}
return 1;}

if(strcmp(cmd, "/mostrarstatus", true) == 0) {
if(!IsPlayerSpawned(playerid)) return 1;
if(MostrandoStatus[playerid] == 0){
MostrandoStatus[playerid] = 1;
TextDrawShowForPlayer(playerid,Status[playerid]);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Status ativado");
}else{
MostrandoStatus[playerid] = 0;
TextDrawHideForPlayer(playerid,Status[playerid]);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Status desativado");}
return 1;}

if(strcmp(cmd, "/ncc", true) == 0) {
if(NascerComColete[playerid] == false){
NascerComColete[playerid] = true;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você nascerá com colete, custará $5000 por spawn");
}else{
NascerComColete[playerid] = false;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você não nascerá com colete");}
return 1;}

if(strcmp(cmd, "/nkw", true) == 0) {
if(NascerComKw[playerid] == false){
NascerComKw[playerid] = true;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você nascerá com Kit Walk, custará $15000 por spawn");
}else{
NascerComKw[playerid] = false;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você não nascerá com Kit Walk");}
return 1;}

if(strcmp(cmd, "/nkr", true) == 0) {
if(NascerComKr[playerid] == false){
NascerComKr[playerid] = true;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você nascerá com Kit Run, custará $15000 por spawn");
}else{
NascerComKr[playerid] = false;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você não nascerá com Kit Run");}
return 1;}

if(strcmp(cmd, "/nkt", true) == 0) {
if(NascerComTp[playerid] == false){
NascerComTp[playerid] = true;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você nascerá com Kit Top, custará $30000 por spawn");
}else{
NascerComTp[playerid] = false;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você não nascerá com Kit Top");}
return 1;}

if(strcmp(cmd, "/admmsg", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(MensagemADMAtivado == 0){
dini_IntSet("ZNS.ini","admmsgs",1);
MensagemADMAtivado = 1;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Mensagens para administração ativadas!");
}else{
dini_IntSet("ZNS.ini","admmsgs",0);
MensagemADMAtivado = 0;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Mensagens para administração desativadas!");}
return 1;}

if(strcmp(cmd, "/nck", true) == 0) {
if(NascerComKitGuerra[playerid] == false){
NascerComKitGuerra[playerid] = true;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você nascerá com Kit Guerra, custará $10000 por spawn");
}else{
NascerComKitGuerra[playerid] = false;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você não nascerá com Kit Guerra");}
return 1;}

if(strcmp(cmd, "/sairrc", true) == 0) {
if(!IsPlayerSpawned(playerid)) return 1;
if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não esta em um veículo RC");
new modelo = GetVehicleModel(GetPlayerVehicleID(playerid));
if(modelo != 441 && modelo != 464 && modelo && 465 && modelo != 501 && modelo != 564) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não esta em um veículo RC");
new Float:playerposx, Float:playerposy, Float:playerposz;
GetPlayerPos(playerid, playerposx, playerposy, playerposz);
SetPlayerPos(playerid,playerposx, playerposy, playerposz+2);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você saiu do veículo RC");
return 1;}

if(strcmp(cmd, "/painel", true) == 0) {
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(veiculo[playerid] == 0){SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não tem veículo próprio, escolha um: /CS"); return 1;}
MostrarMenuPainel(playerid);
return 1;}

if(strcmp(cmd, "/pintar", true) == 0) {
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(veiculo[playerid] == 0){SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não tem veículo próprio, escolha um: /CS"); return 1;}
ShowPlayerDialog(playerid,994,DIALOG_STYLE_LIST,"Escolha a pintura para seu veiculo:","Escolher cor aleatoria (Qualquer)\nEfeitos especiais (Piscando)\nCor personalizada (Inserir ID)\nRoxo\nMarrom\nPink\nVerde claro\nVerde escuro\nVerde dark\nCinza\nVermelho marrom\nRosa\nVermelho claro\nAzul bebe\nAzul claro\nAzul escuro\nMarrom\nBranco\nVermelho alaranjado\nVermelho rosado\nVinho\nGelo\nAmarelo\nAzul marinho\nRosado\nVerde","Selecionar","Voltar");
return 1;}

if(strcmp(cmd, "/ac", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(NoEvento[playerid] == 1 && EventoACEF == false && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não pode usar efeitos e nem acessórios neste evento");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
MostrarDialogoAcessorios1(playerid);
return 1;}

if(strcmp(cmd, "/efeitos", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(NoEvento[playerid] == 1 && EventoACEF == false && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não pode usar efeitos e nem acessórios neste evento");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
MostrarDialogoEfeitos(playerid);
return 1;}

if(strcmp(cmd, "/tugc", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(UltraGCAtivoParaTodos == 0){
UltraGCAtivoParaTodos = 1;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: ULTRA GC ATIVO!");
}else{
DesativarUGC();
UltraGCAtivoParaTodos = 0;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: ULTRA GC BLOQUEADO!");
}return 1;}


if (strcmp("/ultragc", cmdtext, true) == 0 || strcmp("/ugc", cmdtext, true) == 0 || strcmp("/ugodc", cmdtext, true) == 0){
if(!IsPlayerSpawned(playerid)){return 1;}
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 3) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(UltraGCAtivoParaTodos != 1) return SendClientMessage(playerid,COLOUR_ERRO,"ERRO: O UltraGC foi desabilitado");
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"ULTRAGC");
if(UltraGC[playerid] == 0){
GetPlayerHealth(playerid, Float:UltraGC_VIDA[playerid]);
GetPlayerArmour(playerid, Float:UltraGC_COLETE[playerid]);
SetPlayerHealth(playerid,100.0);
SetPlayerArmour(playerid,0.0);
UltraGC[playerid] = 1;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: ULTRA GOD-CAR ATIVADO!");
}else{
UltraGC[playerid] = 0;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: ULTRA GOD-CAR DESATIVADO!");
SetPlayerHealth(playerid,Float:UltraGC_VIDA[playerid]);
SetPlayerArmour(playerid,Float:UltraGC_COLETE[playerid]);
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){SetVehicleHealth(GetPlayerVehicleID(playerid),1000.0);}
}return 1;}

if (strcmp("/organizar", cmdtext, true) == 0){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);{
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"ORGANIZAR");
for(new v; v<UltimoVeiculoGM; v++)if (GetVehicleDriver(v) == -1){
SetVehicleToRespawn(v);}}
SendClientMessageToAll(COLOUR_DICA, "[MANUTENÇÃO RÁPIDA] Todos os veículos do mapa foram estacionados.");
return 1;}

if(strcmp(cmd,"/ejetar", true)==0){
new vehicleid;
new pid;
new playerstate = GetPlayerState(playerid);
tmp = strtok(cmdtext,idx);
if(!IsPlayerInAnyVehicle(playerid)){
SendClientMessage(playerid,COLOUR_AVISO,"[ERRO]: Voce nao esta no carro");
return 1;}
if(playerstate == PLAYER_STATE_PASSENGER){
SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Passageiros nao podem usar isso");
return 1;}
vehicleid = GetPlayerVehicleID(playerid);
if(!strlen(tmp)){
SendClientMessage(playerid,COLOUR_BRANCO,"USO: /ejetar [playerid]");
return 1;}
pid = strval(tmp);
if(!IsPlayerConnected(pid)){
SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: O jogador nao esta conectado...");
return 1;}
if(!IsPlayerInVehicle(pid,vehicleid)){
SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: O jogador nao esta em seu veiculo...");
return 1;
}else{
new Float:playerposx, Float:playerposy, Float:playerposz;
GetPlayerPos(pid, playerposx, playerposy, playerposz);
SetPlayerPos(pid,playerposx+2, playerposy+2, playerposz);
RemovePlayerFromVehicle(pid);
GameTextForPlayer(pid,"~r~VOCE FOI EJETADO!",3000,5);
return 1;}}

if(strcmp(cmdtext, "/rmc", true) == 0) {
if(cor[playerid] != 0){
cor[playerid] = 0;
SetPlayerColor(playerid, playerColors[playerid]);
SendClientMessage(playerid, COLOUR_DICA, "[INFO]: Cor personalizada removida");
}else{SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não tem COR personalizada ( /MC )");}
return 1;}

if(strcmp(cmdtext, "/bandana", true) == 0)
{
	ShowPlayerDialog(playerid,bandana,DIALOG_STYLE_LIST,"Bandana","Bandana 1\nBandana 2\nBandana 3\nBandana 4\nBandana 5\nBandana 6\nBandana 7\nBandana 8\nBandana 9\nBandana 10\nRemover Bandana","OK","Cancelar");
 	return 1;
}

if(strcmp(cmd, "/ms", true) == 0 || strcmp(cmd, "/meuskin", true) == 0 || strcmp(cmd, "/skin", true) == 0){
if(!IsPlayerSpawned(playerid)){return 1;}
if(CallRemoteFunction("GetPlayerArenaStatus","i",playerid) == 1) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[0]);
if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
cmd = strtok(cmdtext, idx);
if(!strlen(cmd)){SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Digite: /ms [ID da Skin]");return 1;}
new param2=strval(cmd);
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2){
if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não pode trocar o skin estando abaixado");}
if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_ENTER_VEHICLE) return 1;
new bool:newskin;
newskin = false;
if(param2==3) newskin = true;
if(param2==4) newskin = true;
if(param2==5) newskin = true;
if(param2==6) newskin = true;
if(param2==8) newskin = true;
if(param2==42) newskin = true;
if(param2==65) newskin = true;
if(param2==86) newskin = true;
if(param2==119) newskin = true;
if(param2==149) newskin = true;
if(param2==208) newskin = true;
if(param2==273) newskin = true;
if(param2==289) newskin = true;
if(newskin == false){
if(param2<7){SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Skin inválido");return 1;}
if(param2==8||param2==42||param2==65||param2==74||param2==86||param2==208||param2==270||param2==271||param2==289){SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não pode escolher este SKIN");return 1;}
if(param2>264 && param2<274){SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Skin inválido");return 1;}
if(param2>311){SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Skin inválido");return 1;}}
SendClientMessage(playerid, COLOUR_DICA, "[INFO]: Seu SKIN foi mudado. Ficará salvo em sua conta");
SendClientMessage(playerid, COLOUR_DICA, "[INFO]: Digite /RMS para não usar mais esse skin");
skin[playerid] = param2;
SetPlayerSkin(playerid, param2);
return 1;}

if(strcmp(cmd, "/cerveja", true) == 0){
SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_BEER);
return 1;}

if(strcmp(cmd, "/vinho", true) == 0){
SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_WINE);
return 1;}

if (strcmp("/cigarro", cmdtext, true) == 0 || strcmp("/fumar", cmdtext, true) == 0 || strcmp("/fumo", cmdtext, true) == 0){
SetPlayerSpecialAction(playerid,SPECIAL_ACTION_SMOKE_CIGGY);
return 1;}

if (strcmp("/refri", cmdtext, true) == 0 || strcmp("/coca", cmdtext, true) == 0 || strcmp("/refrigerante", cmdtext, true) == 0){
SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_SPRUNK);
return 1;}

if(strcmp(cmd, "/horas", true) == 0) {
new string_horas[64], hour,minuite,second; gettime(hour,minuite,second);
format(string_horas, sizeof(string_horas), "~g~|~w~%d:%d~g~|", hour, minuite);
return GameTextForPlayer(playerid, string_horas, 5000, 1);}

if(strcmp(cmd, "/tdarpau", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 3) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(DarPau == 0){
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: DARPAU ATIVADO!");
DarPau = 1;
}else{
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: DARPAU DESATIVADO!");
DarPau = 0;}
return 1;}

if (strcmp("/darpau", cmdtext, true) == 0 ||
strcmp("/cry", cmdtext, true) == 0 ||
strcmp("/lc", cmdtext, true) == 0 ||
strcmp("/emo", cmdtext, true) == 0 ||
strcmp("/gay", cmdtext, true) == 0 ||
strcmp("/graninha", cmdtext, true) == 0 ||
strcmp("/hydra", cmdtext, true) == 0 ||
strcmp("/darcu", cmdtext, true) == 0 ||
strcmp("/queropau", cmdtext, true) == 0 ||
strcmp("/cry", cmdtext, true) == 0 ||
strcmp("/tenso", cmdtext, true) == 0 ||
strcmp("/chifre", cmdtext, true) == 0 ||
strcmp("/cheat", cmdtext, true) == 0 ||
strcmp("/fail", cmdtext, true) == 0 ||
strcmp("/granafacil", cmdtext, true) == 0 ||
strcmp("/mebuga", cmdtext, true) == 0 ||
strcmp("/noob", cmdtext, true) == 0){
if(DarPau == 1){CallRemoteFunction("CrashPlayer","ii",playerid,1);}else{return 0;}
return 1;}

if(strcmp("/msp", cmdtext, true) == 0 || strcmp("/nascer", cmdtext, true) == 0) {
if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(CallRemoteFunction("LocalInvalidoParaSpawn","i",playerid) == 1) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Proibido usar o /MSP ou /NASCER neste local");
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não pode nascer em interiores");
if(ArenaTipo[playerid] == 24 || Arena[playerid] == 1) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não pode usar este comando em arena!");
if(PlayerCustomSpawn[playerid] == 0){
GetPlayerPos(playerid, PlayerCustomSpawn_X[playerid], PlayerCustomSpawn_Y[playerid], PlayerCustomSpawn_Z[playerid]);
PlayerCustomSpawn_I[playerid] = GetPlayerInterior(playerid);
if(IsPlayerInAnyVehicle(playerid)){
GetVehicleZAngle(GetPlayerVehicleID(playerid),PlayerCustomSpawn_F[playerid]);
}else{GetPlayerFacingAngle(playerid, PlayerCustomSpawn_F[playerid]);}
PlayerCustomSpawn[playerid] = 1;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você nascerá aqui, quando morrer");
}else{
PlayerCustomSpawn[playerid] = 0;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você nascerá aleatoriamente por Las Venturas");}
return 1;}


if(strcmp(cmdtext, "/rms", true) == 0) {
if(skin[playerid] != 0){
skin[playerid] = 0;
SendClientMessage(playerid, COLOUR_DICA, "[INFO]: Seu SKIN será removido em sua próxima morte");
}else{SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não tem SKIN personalizado (/MS)");}
return 1;}

if(strcmp(cmd, "/mc", true) == 0) {
if(CallRemoteFunction("GetPlayerArenaStatus","i",playerid) == 1) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[0]);
tmp = strtok(cmdtext, idx);
new param2=strval(tmp);
if(!strlen(tmp)){SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Digite: /mc [ID da Cor (0/300)]");return 1;}
if(!IsNumeric(tmp)){SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você so pode escolher uma cor de 0 a 300");return 1;}
if(param2>300){SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você so pode escolher uma cor de 0 a 300");return 1;}

switch(param2)
{
case 0: cor[playerid]=0xE66C09FF;
case 1: cor[playerid]=0x6241B4FF;
case 2: cor[playerid]=0x00B600FF;
case 3: cor[playerid]=0x0000FFFF;
case 4: cor[playerid]=0x9600C1FF;
case 5: cor[playerid]=0xFF0000FF;
case 6: cor[playerid]=0x956300FF;
case 7: cor[playerid]=0xFF9B00FF;
case 8: cor[playerid]=0xFFFFFFFF;
case 9: cor[playerid]=0xFF00FFFF;
case 10: cor[playerid]=0x78697C5A;
case 11: cor[playerid]=0x5DB7B6FF;
case 12: cor[playerid]=0xCA580FFF;
case 13: cor[playerid]=0x218EBFFF;
case 14: cor[playerid]=0x12FA56FF;
case 15: cor[playerid]=0xAC151EFF;
case 16: cor[playerid]=0xDC53AEFF;
case 17: cor[playerid]=0x382ECDFF;
case 18: cor[playerid]=0x566912FF;
case 19: cor[playerid]=0xD1D962FF;
case 20: cor[playerid]=0x87598FFF;
case 21: cor[playerid]=0x8D4CFDFF;
case 22: cor[playerid]=0xFB880DFF;
case 23: cor[playerid]=0x67DDC6FF;
case 24: cor[playerid]=0xF8E158FF;
case 25: cor[playerid]=0x89CE13FF;
case 26: cor[playerid]=0xAD1401FF;
case 27: cor[playerid]=0x7476E0FF;
case 28: cor[playerid]=0x776049FF;
case 29: cor[playerid]=0x30B673FF;
case 30: cor[playerid]=0xC191BDFF;
case 31: cor[playerid]=0x375FD6FF;
case 32: cor[playerid]=0xFFFFFFFF;
case 33: cor[playerid]=0x59145CFF;
case 34: cor[playerid]=0x8C759EFF;
case 35: cor[playerid]=0x015C8DFF;
case 36: cor[playerid]=0x4E6552FF;
case 37: cor[playerid]=0xEFA602FF;
case 38: cor[playerid]=0x8815A2FF;
case 39: cor[playerid]=0xA96089FF;
case 40: cor[playerid]=0x772F58FF;
case 41: cor[playerid]=0xEA59E5FF;
case 42: cor[playerid]=0x83F9F8FF;
case 43: cor[playerid]=0xCD846DFF;
case 44: cor[playerid]=0x52F740FF;
case 45: cor[playerid]=0x3390D9FF;
case 46: cor[playerid]=0x044C64FF;
case 47: cor[playerid]=0xFE446DFF;
case 48: cor[playerid]=0xF10CC2FF;
case 49: cor[playerid]=0x715AD0FF;
case 50: cor[playerid]=0x7E556CFF;
case 51: cor[playerid]=0x1171E3FF;
case 52: cor[playerid]=0xA60FF7FF;
case 53: cor[playerid]=0x5C4592FF;
case 54: cor[playerid]=0x888960FF;
case 55: cor[playerid]=0xE68F46FF;
case 56: cor[playerid]=0x4A934FFF;
case 57: cor[playerid]=0xE4CD84FF;
case 58: cor[playerid]=0x2279A8FF;
case 59: cor[playerid]=0x2FAA34FF;
case 60: cor[playerid]=0xFD7B13FF;
case 61: cor[playerid]=0xB5E86EFF;
case 62: cor[playerid]=0x8F98F8FF;
case 63: cor[playerid]=0x9E1F7EFF;
case 64: cor[playerid]=0xC6DDECFF;
case 65: cor[playerid]=0xE6FD5DFF;
case 66: cor[playerid]=0xE75EEAFF;
case 67: cor[playerid]=0xA2B903FF;
case 68: cor[playerid]=0xC2479EFF;
case 69: cor[playerid]=0x99D1E8FF;
case 70: cor[playerid]=0xCEBCA1FF;
case 71: cor[playerid]=0x4F660CFF;
case 72: cor[playerid]=0x9DDEF5FF;
case 73: cor[playerid]=0x9DDECCFF;
case 74: cor[playerid]=0x9DDE3FFF;
case 75: cor[playerid]=0x9D083FFF;
case 76: cor[playerid]=0xE3083FFF;
case 77: cor[playerid]=0xE3088DFF;
case 78: cor[playerid]=0x4008FCFF;
case 79: cor[playerid]=0xDBBAFCFF;
case 80: cor[playerid]=0xDBBAA4FF;
case 81: cor[playerid]=0x3B84A9FF;
case 82: cor[playerid]=0x41E58BFF;
case 83: cor[playerid]=0x886B43FF;
case 84: cor[playerid]=0x886B43FF;
case 85: cor[playerid]=0xEE7DFDFF;
case 86: cor[playerid]=0xEE5CA5FF;
case 87: cor[playerid]=0x414140FF;
case 88: cor[playerid]=0xC0C2A9FF;
case 89: cor[playerid]=0xC77B29FF;
case 90: cor[playerid]=0x203F96FF;
case 91: cor[playerid]=0x586B7BFF;
case 92: cor[playerid]=0xA26309D7;
case 93: cor[playerid]=0xF6A409D7;
case 94: cor[playerid]=0xF60113D7;
case 95: cor[playerid]=0x062B13D7;
case 96: cor[playerid]=0x62617BD7;
case 97: cor[playerid]=0xE8807BD7;
case 98: cor[playerid]=0xFF522DD7;
case 99: cor[playerid]=0xFFB4D2FF;
case 100: cor[playerid]=0xB3B2B1D7;
case 101: cor[playerid]=0x82B970FF;
case 102: cor[playerid]=0x46FD4FFF;
case 103: cor[playerid]=0x10F8E1FF;
case 104: cor[playerid]=0x3A94EFFF;
case 105: cor[playerid]=0x823E0DFF;
case 106: cor[playerid]=0xA1E6A1FF;
case 107: cor[playerid]=0x6118E2FF;
case 108: cor[playerid]=0xD8269CFF;
case 109: cor[playerid]=0x8EA6D3FF;
case 110: cor[playerid]=0x5C74E0FF;
case 111: cor[playerid]=0x4FD862FF;
case 112: cor[playerid]=0x46EAB9FF;
case 113: cor[playerid]=0x358CA3FF;
case 114: cor[playerid]=0xD1FEE4FF;
case 115: cor[playerid]=0xB6994FFF;
case 116: cor[playerid]=0xA4F560FF;
case 117: cor[playerid]=0x23146BFF;
case 118: cor[playerid]=0x7A1DBBFF;
case 119: cor[playerid]=0x7A1DE6FF;
case 120: cor[playerid]=0xFE1DE6FF;
case 121: cor[playerid]=0xFE1D3FFF;
case 122: cor[playerid]=0xFE0000FF;
case 123: cor[playerid]=0x134B70FF;
case 124: cor[playerid]=0x869899FF;
case 125: cor[playerid]=0xF9E299FF;
case 126: cor[playerid]=0xF9E2E2FF;
case 127: cor[playerid]=0x329F48FF;
case 128: cor[playerid]=0x7EBFBBFF;
case 129: cor[playerid]=0x7648BBFF;
case 130: cor[playerid]=0x76488BFF;
case 131: cor[playerid]=0x5617DBFF;
case 132: cor[playerid]=0x36F7F7FF;
case 133: cor[playerid]=0xAB866FFF;
case 134: cor[playerid]=0xE5866FFF;
case 135: cor[playerid]=0xE586C3FF;
case 136: cor[playerid]=0xE58605FF;
case 137: cor[playerid]=0x5F7A69FF;
case 138: cor[playerid]=0xBF3217FF;
case 139: cor[playerid]=0x078D4EFF;
case 140: cor[playerid]=0x00FF00FF;
case 141: cor[playerid]=0xAFE644FF;
case 142: cor[playerid]=0xE51986FF;
case 143: cor[playerid]=0x9CCAA4FF;
case 144: cor[playerid]=0xA2AB18FF;
case 145: cor[playerid]=0xDD54FBFF;
case 146: cor[playerid]=0x5854FBFF;
case 147: cor[playerid]=0xB95A2EFF;
case 148: cor[playerid]=0x01B4B6FF;
case 149: cor[playerid]=0x0D80C9FF;
case 150: cor[playerid]=0x362398FF;
case 151: cor[playerid]=0x2F2C78FF;
case 152: cor[playerid]=0x01AF38FF;
case 153: cor[playerid]=0xE42F3DFF;
case 154: cor[playerid]=0xE4DADBFF;
case 155: cor[playerid]=0x0F047FFF;
case 156: cor[playerid]=0xA71269FF;
case 157: cor[playerid]=0xCC4E0AFF;
case 158: cor[playerid]=0x8959ADFF;
case 159: cor[playerid]=0xC6A043FF;
case 160: cor[playerid]=0x2F6546FF;
case 161: cor[playerid]=0x916596FF;
case 162: cor[playerid]=0xD0FF0EFF;
case 163: cor[playerid]=0x46A771FF;
case 164: cor[playerid]=0x00766BFF;
case 165: cor[playerid]=0xEA1DA2FF;
case 166: cor[playerid]=0x371C66FF;
case 167: cor[playerid]=0xE94321FF;
case 168: cor[playerid]=0x64689EFF;
case 169: cor[playerid]=0x069824FF;
case 170: cor[playerid]=0x18A5F7FF;
case 171: cor[playerid]=0x8E186FFF;
case 172: cor[playerid]=0xCD6E0BFF;
case 173: cor[playerid]=0x16C812FF;
case 174: cor[playerid]=0xCB5039FF;
case 175: cor[playerid]=0xEA2C43FF;
case 176: cor[playerid]=0x3066B3FF;
case 177: cor[playerid]=0xF8025AFF;
case 178: cor[playerid]=0x1B24F0FF;
case 179: cor[playerid]=0xC37AF0FF;
case 180: cor[playerid]=0xC3CC9FFF;
case 181: cor[playerid]=0xFFE1FFFF;
case 182: cor[playerid]=0xFF00FFFF;
case 183: cor[playerid]=0x728D53FF;
case 184: cor[playerid]=0x72BF17FF;
case 185: cor[playerid]=0x01AEEDFF;
case 186: cor[playerid]=0xFD0A71FF;
case 187: cor[playerid]=0xFDD070FF;
case 188: cor[playerid]=0xE9B1A0FF;
case 189: cor[playerid]=0x66CCDFFF;
case 190: cor[playerid]=0x66CC83FF;
case 191: cor[playerid]=0xED8507FF;
case 192: cor[playerid]=0x48439AFF;
case 193: cor[playerid]=0x6476DFFF;
case 194: cor[playerid]=0x6FB41DFF;
case 195: cor[playerid]=0x1922ABFF;
case 196: cor[playerid]=0xB53EB1FF;
case 197: cor[playerid]=0xB9FDB1FF;
case 198: cor[playerid]=0xB9FDFEFF;
case 199: cor[playerid]=0xE0F3FEFF;
case 200: cor[playerid]=0xE0F3CBFF;
case 201: cor[playerid]=0xD0243FFF;
case 202: cor[playerid]=0xED3BF1FF;
case 203: cor[playerid]=0xD77C94FF;
case 204: cor[playerid]=0x0B54F8FF;
case 205: cor[playerid]=0x4BD448FF;
case 206: cor[playerid]=0x5F76A3FF;
case 207: cor[playerid]=0x2DB6BFFF;
case 208: cor[playerid]=0x5A08E0FF;
case 209: cor[playerid]=0x440D80FF;
case 210: cor[playerid]=0x2D794CFF;
case 211: cor[playerid]=0xB5D691FF;
case 212: cor[playerid]=0x448871FF;
case 213: cor[playerid]=0x0868C1FF;
case 214: cor[playerid]=0xFAFEE6FF;
case 215: cor[playerid]=0x4C795EFF;
case 216: cor[playerid]=0x3B16FEFF;
case 217: cor[playerid]=0x965B43FF;
case 218: cor[playerid]=0x5F5BE4FF;
case 219: cor[playerid]=0xA4FBE0FF;
case 220: cor[playerid]=0xECA0AAFF;
case 221: cor[playerid]=0x237A91FF;
case 222: cor[playerid]=0x2940EDFF;
case 223: cor[playerid]=0x575378FF;
case 224: cor[playerid]=0x585D46FF;
case 225: cor[playerid]=0xC22BD3FF;
case 226: cor[playerid]=0xC2B0EBFF;
case 227: cor[playerid]=0x87C3F0FF;
case 228: cor[playerid]=0x610E89FF;
case 229: cor[playerid]=0x7EF52CFF;
case 230: cor[playerid]=0x3663EDFF;
case 231: cor[playerid]=0x8D4960FF;
case 232: cor[playerid]=0x2A4FA6FF;
case 233: cor[playerid]=0x6A7C61FF;
case 234: cor[playerid]=0xF521B9FF;
case 235: cor[playerid]=0x1FE8A4FF;
case 236: cor[playerid]=0x385265FF;
case 237: cor[playerid]=0xAABD0BFF;
case 238: cor[playerid]=0xD3270DFF;
case 239: cor[playerid]=0x3D498EFF;
case 240: cor[playerid]=0x7C61CEFF;
case 241: cor[playerid]=0x263D38FF;
case 242: cor[playerid]=0xF20679FF;
case 243: cor[playerid]=0xF38A85FF;
case 244: cor[playerid]=0x9942C0FF;
case 245: cor[playerid]=0x31DE79FF;
case 246: cor[playerid]=0x31DEEFFF;
case 247: cor[playerid]=0x23C2ABFF;
case 248: cor[playerid]=0xC27759FF;
case 249: cor[playerid]=0xC2BB3DFF;
case 250: cor[playerid]=0xC258A1FF;
case 251: cor[playerid]=0x2258A1FF;
case 252: cor[playerid]=0x22FBA1FF;
case 253: cor[playerid]=0x8F537CFF;
case 254: cor[playerid]=0x7D1C50FF;
case 255: cor[playerid]=0xE71C50FF;
case 256: cor[playerid]=0xE7A724FF;
case 257: cor[playerid]=0x38A724FF;
case 258: cor[playerid]=0xACF024FF;
case 259: cor[playerid]=0x675BA9FF;
case 260: cor[playerid]=0xB49995FF;
case 261: cor[playerid]=0x1DFC95FF;
case 262: cor[playerid]=0x1DFC38FF;
case 263: cor[playerid]=0x1D0238FF;
case 264: cor[playerid]=0x1D0281FF;
case 265: cor[playerid]=0xAB616AFF;
case 266: cor[playerid]=0x544A45FF;
case 267: cor[playerid]=0xC64A45FF;
case 268: cor[playerid]=0xC64AD4FF;
case 269: cor[playerid]=0xC9E3D4FF;
case 270: cor[playerid]=0x05A4B3FF;
case 271: cor[playerid]=0xC19C6FFF;
case 272: cor[playerid]=0x245003FF;
case 273: cor[playerid]=0x00DFFFFF;
case 274: cor[playerid]=0x0093FFFF;
case 275: cor[playerid]=0x00933AFF;
case 276: cor[playerid]=0xBAD43AFF;
case 277: cor[playerid]=0xBAD477FF;
case 278: cor[playerid]=0xBA2B9DFF;
case 279: cor[playerid]=0xF8267DFF;
case 280: cor[playerid]=0x47EF50FF;
case 281: cor[playerid]=0x47F59AFF;
case 282: cor[playerid]=0x05209AFF;
case 283: cor[playerid]=0x8896A5FF;
case 284: cor[playerid]=0xD296A5FF;
case 285: cor[playerid]=0xD29662FF;
case 286: cor[playerid]=0xD2559AFF;
case 287: cor[playerid]=0xBAA2FBFF;
case 288: cor[playerid]=0x18A2FBFF;
case 289: cor[playerid]=0x2607B7FF;
case 290: cor[playerid]=0xAC3716FF;
case 291: cor[playerid]=0x8F7AB4FF;
case 292: cor[playerid]=0x8F7AFAFF;
case 293: cor[playerid]=0xED7AFAFF;
case 294: cor[playerid]=0xED6E53FF;
case 295: cor[playerid]=0x5EC653FF;
case 296: cor[playerid]=0xEF3663FF;
case 297: cor[playerid]=0xEF8751FF;
case 298: cor[playerid]=0xEFF463FF;
case 299: cor[playerid]=0x87E77FFF;
case 300: cor[playerid]=0xB5E26CFF;

}

if(cor[playerid] != 0){SetPlayerColor(playerid,cor[playerid]);}
SendClientMessage(playerid, GetPlayerColor(playerid), "[INFO]: Sua COR foi mudada. Ficará salva em sua conta");
SendClientMessage(playerid, GetPlayerColor(playerid), "[INFO]: Digite /rmc para não usar mais essa cor.");
SendClientMessage(playerid, GetPlayerColor(playerid), "[DICA]: Você pode colocar via código HEX através do: /HMC");
return 1;}

if(strcmp(cmd, "/transferir", true) == 0 || strcmp(cmd, "/dargrana", true) == 0 || strcmp(cmd, "/dardinheiro", true) == 0) {
if(CallRemoteFunction("GetPlayerRegisteredAndLogged","i",playerid) != 1){SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Para usar este comando você deve estar registrado e logado"); return 1;}
new playermoney;
new sendername[MAX_PLAYER_NAME];
new giveplayer[MAX_PLAYER_NAME];
new giveplayerid, moneys;
tmp = strtok(cmdtext, idx);
if(!strlen(tmp)) {
SendClientMessage(playerid, COLOUR_BRANCO, "[USO]: /transferir [playerid] [quantia]");
return 1;}
giveplayerid = strval(tmp);
tmp = strtok(cmdtext, idx);
if(!strlen(tmp)) {
SendClientMessage(playerid, COLOUR_BRANCO, "[USO]: /transferir [playerid] [quantia]");
return 1;}
moneys = strval(tmp);
if(moneys > 5000){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2){
SendClientMessage(playerid, 0xFF0000AA, "[ERRO]: O limite máximo de transferência é $5000 por vez.");
return 1;}}
if(transferencias[playerid] >= 10)if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2){{return SendClientMessage(playerid, 0xFF0000AA, "[INFO]: Já transferiu demais por hoje né?");}}
if(IsPlayerConnected(giveplayerid)) {
if(CallRemoteFunction("GetPlayerCash", "i", playerid) < moneys) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não possui esta quantidade de dinheiro");
if(playerid == giveplayerid) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não pode transferir dinheiro para você mesmo");
GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
GetPlayerName(playerid, sendername, sizeof(sendername));
playermoney = CallRemoteFunction("GetPlayerCash", "i", playerid);
if (moneys > 0 && playermoney >= moneys) {
CallRemoteFunction("GivePlayerCash", "ii", playerid, (0 - moneys));
CallRemoteFunction("GivePlayerCash", "ii", giveplayerid, moneys);
format(string, sizeof(string), "[INFO]: Você transferiu a %s (ID:%d), $%d.", giveplayer,giveplayerid, moneys);
SendClientMessage(playerid, COLOUR_AVISO, string);
format(string, sizeof(string), "[INFO]: Você recebeu $%d de %s (ID:%d).", moneys, sendername, playerid);
SendClientMessage(giveplayerid, COLOUR_AVISO, string);
printf("%s(playerid:%d) transferiu %d para %s(playerid:%d)",sendername, playerid, moneys, giveplayer, giveplayerid);
transferencias[playerid]++;}else{
SendClientMessage(playerid, COLOUR_AVISO, "[ERRO]: Transação inválida.");}}else {
format(string, sizeof(string), "[ERRO]: ID %d não está online.", giveplayerid);
SendClientMessage(playerid, COLOUR_AVISO, string);}
return 1;}

if(strcmp("/mis", cmdtext, true) == 0 || strcmp("/miss", cmdtext, true) == 0 || strcmp("/missoes", cmdtext, true) == 0 || strcmp("/missions", cmdtext, true) == 0) {
if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não está em um veículo como motorista.");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
new VX;
switch(GetVehicleModel( GetPlayerVehicleID(playerid))){

case 530:{
VMissaoString[playerid] = "Empilhador"; //64
PlayerMissaoTipo[playerid] = 1;
VX = 4;}

case 411,541,494,451:{
VMissaoString[playerid] = "Entrega Ultra-Rapida"; //200
PlayerMissaoTipo[playerid] = 1;
VX = 1;}

case 475,576:{
VMissaoString[playerid] = "Entrega Rapida"; //147
PlayerMissaoTipo[playerid] = 1;
VX = 2;}

case 468,586,463,521,461,581:{
VMissaoString[playerid] = "Motoboy"; //147
PlayerMissaoTipo[playerid] = 1;
VX = 2;}

case 478:{
VMissaoString[playerid] = "Frete Rapido"; //106
PlayerMissaoTipo[playerid] = 1;
VX = 3;}

case 448:{
VMissaoString[playerid] = "Entregador de Pizza"; //99 155 BUGANDO
PlayerMissaoTipo[playerid] = 1;
VX = 2;}

case 437:{
VMissaoString[playerid] = "Motorista de Onibus"; //143
PlayerMissaoTipo[playerid] = 1;
VX = 2;}

case 431:{
VMissaoString[playerid] = "Motorista de Onibus"; //118
PlayerMissaoTipo[playerid] = 1;
VX = 3;}

case 407:{
VMissaoString[playerid] = "Motorista dos Bombeiros"; //134
PlayerMissaoTipo[playerid] = 1;
VX = 2;}

case 420:{
VMissaoString[playerid] = "Taxista"; //131
PlayerMissaoTipo[playerid] = 1;
VX = 2;}

case 416:{
VMissaoString[playerid] = "Motorista de Ambulancia"; //139
PlayerMissaoTipo[playerid] = 1;
VX = 2;}

case 438:{
VMissaoString[playerid] = "Taxista"; //129
PlayerMissaoTipo[playerid] = 1;
VX = 2;}

case 427:{
VMissaoString[playerid] = "Motorista do FBI"; //150
PlayerMissaoTipo[playerid] = 1;
VX = 2;}

case 596,598,597,599:{
VMissaoString[playerid] = "Ronda Policial"; //159
PlayerMissaoTipo[playerid] = 1;
VX = 2;}

case 442:{
VMissaoString[playerid] = "Funeraria"; //126
PlayerMissaoTipo[playerid] = 1;
VX = 2;}

case 525:{
if(GetVehicleTrailer(GetPlayerVehicleID(playerid)) == 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O caminhão deve ter um reboque engatado");
VMissaoString[playerid] = "Guincho"; //145
PlayerMissaoTipo[playerid] = 1;
VX = 3;}

case 588:{
VMissaoString[playerid] = "Vendedor de HotDog"; //97
PlayerMissaoTipo[playerid] = 1;
VX = 3;}

case 524:{
VMissaoString[playerid] = "Cimenteiro"; //118
PlayerMissaoTipo[playerid] = 1;
VX = 3;}

case 403,514,515:{
if(GetVehicleTrailer(GetPlayerVehicleID(playerid)) == 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O caminhão deve ter um reboque engatado");
VMissaoString[playerid] = "Carreteiro"; //99
PlayerMissaoTipo[playerid] = 1;
VX = 3;}

case 531,572,486,532:{
VMissaoString[playerid] = "Tratorista"; //64
PlayerMissaoTipo[playerid] = 1;
VX = 4;}

case 408:{
VMissaoString[playerid] = "Lixeiro"; //90
PlayerMissaoTipo[playerid] = 1;
VX = 3;}

case 552:{
VMissaoString[playerid] = "Limpeza Pública"; //110
PlayerMissaoTipo[playerid] = 1;
VX = 3;}

case 423:{
VMissaoString[playerid] = "Sorveteiro"; //89
PlayerMissaoTipo[playerid] = 1;
VX = 4;}

case 509,481,510:{
VMissaoString[playerid] = "Entregador de Jornal"; //89
PlayerMissaoTipo[playerid] = 1;
VX = 3;}

case 582:{
VMissaoString[playerid] = "Jornalista"; //123
PlayerMissaoTipo[playerid] = 1;
VX = 2;}

case 574:{
VMissaoString[playerid] = "Limpador de Rua"; //55
PlayerMissaoTipo[playerid] = 1;
VX = 5;}

case 409:{
VMissaoString[playerid] = "Motorista de Limo"; //143
PlayerMissaoTipo[playerid] = 1;
VX = 2;}

case 428:{
VMissaoString[playerid] = "Carro Forte"; //142
PlayerMissaoTipo[playerid] = 1;
VX = 2;}

case 414:{
VMissaoString[playerid] = "Caminhoneiro"; //96
PlayerMissaoTipo[playerid] = 1;
VX = 3;}

case 455:{
VMissaoString[playerid] = "Caminhoneiro"; //143
PlayerMissaoTipo[playerid] = 1;
VX = 2;}

case 578:{
VMissaoString[playerid] = "Caminhoneiro"; //118
PlayerMissaoTipo[playerid] = 1;
VX = 3;}

case 609:{
VMissaoString[playerid] = "Transportador"; //98
PlayerMissaoTipo[playerid] = 1;
VX = 3;}

case 592,577:{
VMissaoString[playerid] = "Piloto";
PlayerMissaoTipo[playerid] = 2;
VX = 2;}

case 511,512,593,520,553,476,519,460,513:{
VMissaoString[playerid] = "Piloto";
PlayerMissaoTipo[playerid] = 2;
VX = 1;}

case 537,538,449:{
VMissaoString[playerid] = "Maquinista"; //98
PlayerMissaoTipo[playerid] = 3;
VX = 1;}

case 548,425,417,487,488,497,563,447,469:{
VMissaoString[playerid] = "Piloto de Helicoptero";
PlayerMissaoTipo[playerid] = 4;
VX = 1;}

}
if(VX == 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você precisa de um veículo adequado");

DistanciaMis[playerid] = 0;
DistanciaMis2[playerid] = 0;

if(PlayerMissaoTipo[playerid] == 1){ //MISSÕES DE VEÍCULOS POR TERRA
VMissaoTick[playerid] = 0;
VPlayerMissao[playerid] = 1;
new rand = random(sizeof(VMissoesDestinosCOO));
SetPlayerCheckpoint(playerid, VMissoesDestinosCOO[rand][0], VMissoesDestinosCOO[rand][1], VMissoesDestinosCOO[rand][2], 6.0);
VMissaoPosX[playerid] = VMissoesDestinosCOO[rand][0];
VMissaoPosY[playerid] = VMissoesDestinosCOO[rand][1];
VMissaoPosZ[playerid] = VMissoesDestinosCOO[rand][2];
VMissaoDestinoTXT[playerid] = VMissoesDestinosTXT[rand];
VMissaoDistancia[playerid] = DistanciaAtePonto(playerid, VMissaoPosX[playerid],VMissaoPosY[playerid],VMissaoPosZ[playerid]);
VPlayerMissaoLucro[playerid] = VMissaoDistancia[playerid] * VX + 23;
if(VPlayerMissaoLucro[playerid] > 20000){VPlayerMissaoLucro[playerid] = 20000;}
new mst2[128];format(mst2, sizeof(mst2), "Sua missão: %s", VMissaoString[playerid]);
format(string, sizeof(string), "Destino: %s - Lucro: $%i - Distancia: %i metros",VMissaoDestinoTXT[playerid],VPlayerMissaoLucro[playerid],VMissaoDistancia[playerid]);
SendClientMessage(playerid, COLOUR_BRANCO," ");
SendClientMessage(playerid, COLOUR_INFORMACAO,mst2);
SendClientMessage(playerid, COLOUR_INFORMACAO,string);
SendClientMessage(playerid, COLOUR_BRANCO," ");
PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
RepairVehicle(GetPlayerVehicleID(playerid));}

if(PlayerMissaoTipo[playerid] == 2){ //MISSÕES DE AVIAÇÃO
VMissaoTick[playerid] = 0;
VPlayerMissao[playerid] = 1;
new rand = random(sizeof(AMissoesDestinosCOO));
SetPlayerCheckpoint(playerid, AMissoesDestinosCOO[rand][0], AMissoesDestinosCOO[rand][1], AMissoesDestinosCOO[rand][2], 2.0);
VMissaoPosX[playerid] = AMissoesDestinosCOO[rand][0];
VMissaoPosY[playerid] = AMissoesDestinosCOO[rand][1];
VMissaoPosZ[playerid] = AMissoesDestinosCOO[rand][2];
VMissaoDestinoTXT[playerid] = AMissoesDestinosTXT[rand];
VMissaoDistancia[playerid] = DistanciaAtePonto(playerid, VMissaoPosX[playerid],VMissaoPosY[playerid],VMissaoPosZ[playerid]);
VPlayerMissaoLucro[playerid] = VMissaoDistancia[playerid] * VX / 2 + 23;
if(VPlayerMissaoLucro[playerid] > 20000){VPlayerMissaoLucro[playerid] = 20000;}
new mst2[128];format(mst2, sizeof(mst2), "Sua missão: %s", VMissaoString[playerid]);
format(string, sizeof(string), "Destino: %s - Lucro: $%i - Distancia: %i metros",VMissaoDestinoTXT[playerid],VPlayerMissaoLucro[playerid],VMissaoDistancia[playerid]);
SendClientMessage(playerid, COLOUR_BRANCO," ");
SendClientMessage(playerid, COLOUR_INFORMACAO,mst2);
SendClientMessage(playerid, COLOUR_INFORMACAO,string);
SendClientMessage(playerid, COLOUR_BRANCO," ");
RepairVehicle(GetPlayerVehicleID(playerid));}

if(PlayerMissaoTipo[playerid] == 3){ //MISSÕES DE MAQUINISTA
VMissaoTick[playerid] = 0;
VPlayerMissao[playerid] = 1;
new rand = random(sizeof(TMissoesDestinosCOO));
SetPlayerCheckpoint(playerid, TMissoesDestinosCOO[rand][0], TMissoesDestinosCOO[rand][1], TMissoesDestinosCOO[rand][2], 10.0);
VMissaoPosX[playerid] = TMissoesDestinosCOO[rand][0];
VMissaoPosY[playerid] = TMissoesDestinosCOO[rand][1];
VMissaoPosZ[playerid] = TMissoesDestinosCOO[rand][2];
VMissaoDestinoTXT[playerid] = TMissoesDestinosTXT[rand];
VMissaoDistancia[playerid] = DistanciaAtePonto(playerid, VMissaoPosX[playerid],VMissaoPosY[playerid],VMissaoPosZ[playerid]);
VPlayerMissaoLucro[playerid] = VMissaoDistancia[playerid] * VX / 2 + 23;
if(VPlayerMissaoLucro[playerid] > 20000){VPlayerMissaoLucro[playerid] = 20000;}
new mst2[128];format(mst2, sizeof(mst2), "Sua missão: %s", VMissaoString[playerid]);
format(string, sizeof(string), "Destino: %s - Lucro: $%i - Distancia: %i metros",VMissaoDestinoTXT[playerid],VPlayerMissaoLucro[playerid],VMissaoDistancia[playerid]);
SendClientMessage(playerid, COLOUR_BRANCO," ");
SendClientMessage(playerid, COLOUR_INFORMACAO,mst2);
SendClientMessage(playerid, COLOUR_INFORMACAO,string);
SendClientMessage(playerid, COLOUR_BRANCO," ");
RepairVehicle(GetPlayerVehicleID(playerid));}

if(PlayerMissaoTipo[playerid] == 4){ //MISSÕES DE AVIAÇÃO (HELI)
VMissaoTick[playerid] = 0;
VPlayerMissao[playerid] = 1;
new rand = random(sizeof(HMissoesDestinosCOO));
SetPlayerCheckpoint(playerid, HMissoesDestinosCOO[rand][0], HMissoesDestinosCOO[rand][1], HMissoesDestinosCOO[rand][2], 2.0);
VMissaoPosX[playerid] = HMissoesDestinosCOO[rand][0];
VMissaoPosY[playerid] = HMissoesDestinosCOO[rand][1];
VMissaoPosZ[playerid] = HMissoesDestinosCOO[rand][2];
VMissaoDestinoTXT[playerid] = HMissoesDestinosTXT[rand];
VMissaoDistancia[playerid] = DistanciaAtePonto(playerid, VMissaoPosX[playerid],VMissaoPosY[playerid],VMissaoPosZ[playerid]);
VPlayerMissaoLucro[playerid] = VMissaoDistancia[playerid] * VX / 2 + 23;
if(VPlayerMissaoLucro[playerid] > 20000){VPlayerMissaoLucro[playerid] = 20000;}
new mst2[128];format(mst2, sizeof(mst2), "Sua missão: %s", VMissaoString[playerid]);
format(string, sizeof(string), "Destino: %s - Lucro: $%i - Distancia: %i metros",VMissaoDestinoTXT[playerid],VPlayerMissaoLucro[playerid],VMissaoDistancia[playerid]);
SendClientMessage(playerid, COLOUR_BRANCO," ");
SendClientMessage(playerid, COLOUR_INFORMACAO,mst2);
SendClientMessage(playerid, COLOUR_INFORMACAO,string);
SendClientMessage(playerid, COLOUR_BRANCO," ");
RepairVehicle(GetPlayerVehicleID(playerid));}

return 1;}

if(strcmp("/adstart", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(AAD_EmProgresso == 1 || AAD_Lobby == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O combate A/D já está em execução ou em lobby");
KillTimer(AAD_Timer);
AAD_DefLobby();
return 1;}

if(strcmp("/PVCSTART", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(PVC_EmProgresso == 1 || PVC_Lobby == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O combate PVC já está em execução");
KillTimer(PVC_Timer);
PVC_DefLobby();
return 1;}

if(strcmp("/plstart", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(PL_EmProgresso == 1 || PL_Lobby == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O combate PL já está em execução");
KillTimer(PL_Timer);
PL_DefLobby();
return 1;}

if(strcmp("/eamstart", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(EAM_EmProgresso == 1 || EAM_Lobby == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: EAM já está em execução");
SendClientMessage(playerid, COLOUR_INFORMACAO, "[EAM]: Você iniciou!");
KillTimer(EAM_Timer);
EAM_DefLobby();
return 1;}

if(strcmp("/PVCFINALIZAR", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
DestroyPickup(PVC1);
DestroyPickup(PVC2);
DestroyPickup(PVC3);
DestroyPickup(PVC4);
DestroyPickup(PVC5);
DestroyPickup(PVC6);
for(new x=0; x<51; x++){
	DestroyObject(PVC_Objetos[x]);
}
KillTimer(PVC_Timer);
PVC_FinalizaLobby(playerid);
return 1;}

if(strcmp("/PVCDESLIGAR", cmdtext, true) == 0) {
	if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) <= 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
	DestroyPickup(PVC1);
	DestroyPickup(PVC2);
	DestroyPickup(PVC3);
	DestroyPickup(PVC4);
	DestroyPickup(PVC5);
	DestroyPickup(PVC6);
	for(new x=0; x<51; x++){
		DestroyObject(PVC_Objetos[x]);
	}
	KillTimer(PVC_Timer);
return 1;}

if(strcmp("/PLFINALIZAR", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
KillTimer(PL_Timer);
PL_FinalizaLobby(playerid);
return 1;}

if(strcmp("/EAMFINALIZAR", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[EAM]: Você finalizou!");
KillTimer(EAM_Timer);
EAM_FinalizaLobby(playerid);
return 1;}

if(strcmp("/PVCCANCEL", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
PVC_CancelaLobby(playerid);
return 1;}

if(strcmp("/plcancel", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
PL_CancelaLobby(playerid);
return 1;}

if(strcmp("/adcancel", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
AAD_CancelaLobby(playerid);
return 1;}

if(strcmp("/adautooff", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(AAD_EmProgresso == 1 || AAD_Lobby == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O combate A/D já está em execução ou em lobby");
KillTimer(AAD_Timer);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Auto-A/D desativado!");
return 1;}

if(strcmp("/PVCAUTO", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(PVC_EmProgresso == 1 || PVC_Lobby == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O combate PVC já está em execução");
KillTimer(PVC_Timer);
PVC_Timer = SetTimer("PVC_DefLobby",PVC_TIME_IntervaloEntrePartidas, 0);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Auto PVC desativado!");
return 1;}

if(strcmp("/adauto", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(AAD_EmProgresso == 1 || AAD_Lobby == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O combate A/D já está em execução ou em lobby");
KillTimer(AAD_Timer);
AAD_Timer = SetTimer("AAD_DefLobby",AAD_TIME_IntervaloEntrePartidas, 0);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Auto-A/D ativado!");
return 1;}

if(strcmp("/hh", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(HappyHour == 0)
{
UltraGCAtivoParaTodos = 0;
DesativarUGC();
HappyHour = 1;
SendClientMessageToAll(COLOUR_INFORMACAO, "------------------------------------------------------------------------------------------------------");
SendClientMessageToAll(COLOUR_INFORMACAO, "HYDRAS, SEASPARROWS, HUNTERS E RHINOS LIBERADOS!");
SendClientMessageToAll(COLOUR_INFORMACAO, "POR TEMPO LIMITADO! FAÇA JA O SEU: /CS");
SendClientMessageToAll(COLOUR_INFORMACAO, "------------------------------------------------------------------------------------------------------");
GameTextForPlayer(playerid,"~g~NOOB HOUR!!!",2000,3);
}else{
HappyHour = 0;
UltraGCAtivoParaTodos = 1;
AtivarUGC();
SendClientMessageToAll(COLOUR_AVISO, "------------------------------------------------------------------------------------------------------");
SendClientMessageToAll(COLOUR_AVISO, "HYDRAS, SEASPARROWS, HUNTERS E RHINOS BLOQUEADOS!");
SendClientMessageToAll(COLOUR_AVISO, "NOOB HOUR ACABOU! AGORA VÃO DUELAR COMO HOMENS!");
SendClientMessageToAll(COLOUR_AVISO, "------------------------------------------------------------------------------------------------------");
//DESTRUIR VEICULOS BLOQUEADOS
for(new c,a = GetMaxPlayers();c < a;c++){if(IsPlayerConnected(c)){
if(GetVehicleModel(veiculo[c]) == 432){DestroyVehicle(veiculo[c]);veiculo[c] = 0;}
if(GetVehicleModel(veiculo[c]) == 520){DestroyVehicle(veiculo[c]);veiculo[c] = 0;}
if(GetVehicleModel(veiculo[c]) == 447){DestroyVehicle(veiculo[c]);veiculo[c] = 0;}
if(GetVehicleModel(veiculo[c]) == 425){DestroyVehicle(veiculo[c]);veiculo[c] = 0;}
if(GetVehicleModel(veiculo[c]) == 464){DestroyVehicle(veiculo[c]);veiculo[c] = 0;}}}
}return 1;}

if(strcmp(cmd, "/rebans", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"REBANS");
SendClientMessage(playerid,COLOUR_BRANCO,"Recarregando samp.ban...");
SendRconCommand("reloadbans");
SendClientMessage(playerid,COLOUR_BRANCO,"Lista de BANS atualizada!");
return 1;}

if(strcmp(cmd, "/tempo", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"TEMPO");
RandomWeather();
SendClientMessage(playerid,COLOUR_BRANCO,"Tempo mudado.");
return 1;}

if(strcmp(cmd, "/autociclo", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"AUTOCICLO");
AutoCiclo = 1;
dini_IntSet("ZNS.ini","autociclo",AutoCiclo);
clock(1);
SendClientMessage(playerid,COLOUR_BRANCO,"Auto-Ciclo Habilitado.");
return 1;}

if(strcmp(cmd, "/autociclooff", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"AUTOCICLOOFF");
AutoCiclo = 0;
dini_IntSet("ZNS.ini","autociclo",AutoCiclo);
SendClientMessage(playerid,COLOUR_BRANCO,"Auto-Ciclo Desabilitado.");
return 1;}

if(strcmp(cmd, "/yrace", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"YRACE");
SendClientMessage(playerid,COLOUR_BRANCO,"Recarregando yrace...");
SendRconCommand("reloadfs yrace");
SendClientMessage(playerid,COLOUR_BRANCO,"Yrace recarregado!");
return 1;}

if(strcmp(cmd, "/noite", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"NOITE");
SetWorldTime(1);
SendClientMessage(playerid,COLOUR_BRANCO,"Agora esta de noite");
return 1;}

if(strcmp(cmd, "/dia", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"DIA");
SetWorldTime(12);
SendClientMessage(playerid,COLOUR_BRANCO,"Agora esta de dia");
return 1;}

if(strcmp(cmd, "/madrugada", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"MADRUGADA");
SetWorldTime(6);
SendClientMessage(playerid,COLOUR_BRANCO,"Agora esta de madrugada");
return 1;}

if(strcmp(cmd, "/aminigun", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"AMINIGUN");
GivePlayerWeapon(playerid, 38, 99999);
SendClientMessage(playerid,COLOUR_BRANCO,"Admin armado até os dentes!");
return 1;}

if(strcmp(cmd, "/abazuca", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"ABAZUCA");
GivePlayerWeapon(playerid, 35, 99999);
SendClientMessage(playerid,COLOUR_BRANCO,"Admin armado até os dentes!");
return 1;}

if(strcmp(cmd, "/pordosol", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"PORDOSOL");
SetWorldTime(20);
SendClientMessage(playerid,COLOUR_BRANCO,"Agora esta no por do sol");
return 1;}

if(strcmp("/apagarveiculoscs", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){
if(veiculo[i] != 0){
DestroyVehicle(veiculo[i]);
veiculo[i] = 0;}}}
SendClientMessageToAll(COLOUR_DICA, "[MANUTENÇÃO RÁPIDA]: Todos os veículos criados no servidor foram removidos");
return 1;}

if(strcmp("/aw", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(AntiWeapon  == 0){
AntiWeapon = 1;
SendClientMessage(playerid, COLOUR_INFORMACAO, "AntiCheat: AntiWeaponHack Ativado");
}else{
AntiWeapon = 0;
SendClientMessage(playerid, COLOUR_INFORMACAO, "AntiCheat: AntiWeaponHack Desativado");}
return 1;}

if(strcmp("/loader", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(LoaderFreezer  == 0){
LoaderFreezer = 1;
SendClientMessage(playerid, COLOUR_INFORMACAO, "Loader Freezer: Ativado");
}else{
LoaderFreezer = 0;
SendClientMessage(playerid, COLOUR_INFORMACAO, "Loader Freezer: Desativado");}
return 1;}

if(strcmp(cmd, "/objetos", true) == 0 || strcmp(cmd, "/subsistema", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
SendClientMessage(playerid,COLOUR_BRANCO,"Recarregando Subsistema/Objetos...");
SendRconCommand("reloadfs ZNS_Objetos");
SendClientMessage(playerid,COLOUR_BRANCO,"Subsistema/Objetos recarregados!");
return 1;}

if(strcmp(cmd, "/objetosoff", true) == 0 || strcmp(cmd, "/subsistemaoff", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
SendClientMessage(playerid,COLOUR_BRANCO,"Desativando Subsistema/Objetos...");
SendRconCommand("unloadfs ZNS_Objetos");
SendClientMessage(playerid,COLOUR_BRANCO,"Subsistema/Objetos desativados!");
return 1;}

if(strcmp("/EventoTipoDM", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOTIPODM");
EventoNome = "DM";
EventoSPA = false;
EventoSemDanos = false;
EventoOHK = false;
EventoRecarregarLife = true;
EventoKitWalk = false;
EventoKitRun = true;
EventoProibirTele = true;
EventoDarColete = 1;
EventoDarLife = 1;
EventoDarVeiculoID = 0;
EventoDarArmaID = 0;
EventoVeiculos = 0;
EventoCarregar = 0;
EventoDesarmar = 0;
EventoGranadas = 0;
EventoProibirCS = 1;
EventoProibirGC = 0;
EventoProibirFlip = 0;
EventoMatarAoSairVeiculo = 0;
SendClientMessage(playerid,COLOUR_INFORMACAO,"[INFO]: Evento configurado para [EventoTipoDM]! Agora digite /criarevento");
return 1;}

if(strcmp("/EventoTipoDMWalk", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOTIPODMWALK");
EventoNome = "DM WALKING";
EventoSPA = false;
EventoSemDanos = false;
EventoOHK = false;
EventoRecarregarLife = true;
EventoKitWalk = false;
EventoKitRun = true;
EventoProibirTele = true;
EventoDarColete = 1;
EventoDarLife = 1;
EventoDarVeiculoID = 0;
EventoDarArmaID = 0;
EventoVeiculos = 0;
EventoCarregar = 0;
EventoDesarmar = 0;
EventoGranadas = 0;
EventoProibirCS = 1;
EventoProibirGC = 0;
EventoProibirFlip = 0;
EventoMatarAoSairVeiculo = 0;
SendClientMessage(playerid,COLOUR_INFORMACAO,"[INFO]: Evento configurado para [EventoTipoDM]! Agora digite /criarevento");
return 1;}

if(strcmp("/EventoTipoOHK", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) <= 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOTIPOOHK");
EventoNome = "DM HEADSHOT";
EventoSPA = true;
EventoSemDanos = false;
EventoOHK = true;
EventoRecarregarLife = false;
EventoKitWalk = false;
EventoKitRun = false;
EventoProibirTele = true;
EventoDarColete = 0;
EventoDarLife = 1;
EventoDarVeiculoID = 0;
EventoDarArmaID = 23;
EventoVeiculos = 0;
EventoCarregar = 0;
EventoDesarmar = 1;
EventoGranadas = 0;
EventoProibirCS = 1;
EventoProibirGC = 0;
EventoProibirFlip = 0;
EventoMatarAoSairVeiculo = 0;
SendClientMessage(playerid,COLOUR_INFORMACAO,"[INFO]: Evento configurado para [EventoTipoOHK (One Hit Kill)]! Agora digite /criarevento");
return 1;}

if(strcmp("/EventoTipoDMUmaArma", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOTIPODMUMAARMA");
EventoNome = "DM WEAPON";
EventoSPA = false;
EventoSemDanos = false;
EventoOHK = false;
EventoRecarregarLife = true;
EventoKitWalk = false;
EventoKitRun = false;
EventoProibirTele = true;
EventoDarColete = 1;
EventoDarLife = 1;
EventoDarVeiculoID = 0;
EventoDarArmaID = 26;
EventoVeiculos = 0;
EventoCarregar = 0;
EventoDesarmar = 1;
EventoGranadas = 0;
EventoProibirCS = 1;
EventoProibirGC = 0;
EventoProibirFlip = 0;
EventoMatarAoSairVeiculo = 0;
SendClientMessage(playerid,COLOUR_INFORMACAO,"[INFO]: Evento configurado para [EventoTipoDMUmaArma]! Agora digite /criarevento");
return 1;}

if(strcmp("/EventoTipoDerby", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOTIPODERBY");
EventoNome = "DERBY";
EventoSPA = false;
EventoSemDanos = false;
EventoOHK = false;
EventoRecarregarLife = false;
EventoKitWalk = false;
EventoKitRun = false;
EventoProibirTele = true;
EventoDarColete = 0;
EventoDarLife = 0;
EventoDarVeiculoID = 557;
EventoDarArmaID = 0;
EventoVeiculos = 0;
EventoCarregar = 0;
EventoDesarmar = 1;
EventoGranadas = 0;
EventoProibirCS = 1;
EventoProibirGC = 1;
EventoProibirFlip = 1;
EventoMatarAoSairVeiculo = 1;
SendClientMessage(playerid,COLOUR_INFORMACAO,"[INFO]: Evento configurado para [EventoTipoDerby]! Agora digite /criarevento");
return 1;}

if(strcmp("/EventoTipoEncontro", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOTIPOENCONTRO");
EventoNome = "DE FESTA";
EventoSPA = false;
EventoSemDanos = true;
EventoOHK = false;
EventoRecarregarLife = false;
EventoKitWalk = false;
EventoKitRun = false;
EventoProibirTele = false;
EventoDarColete = 0;
EventoDarLife = 0;
EventoDarVeiculoID = 0;
EventoDarArmaID = 0;
EventoVeiculos = 0;
EventoCarregar = 0;
EventoDesarmar = 1;
EventoGranadas = 0;
EventoProibirCS = 1;
EventoProibirGC = 0;
EventoProibirFlip = 0;
EventoMatarAoSairVeiculo = 0;
SendClientMessage(playerid,COLOUR_INFORMACAO,"[INFO]: Evento configurado para [EventoTipoEncontro]! Agora digite /criarevento");
return 1;}

if(strcmp("/EventoTipoCarros", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOTIPOCARROS");
EventoNome = "DE VEICULOS";
EventoSPA = false;
EventoSemDanos = true;
EventoOHK = false;
EventoRecarregarLife = false;
EventoKitWalk = false;
EventoKitRun = false;
EventoProibirTele = false;
EventoDarColete = 0;
EventoDarLife = 0;
EventoDarVeiculoID = 0;
EventoDarArmaID = 0;
EventoVeiculos = 1;
EventoCarregar = 0;
EventoDesarmar = 1;
EventoGranadas = 0;
EventoProibirCS = 0;
EventoProibirGC = 0;
EventoProibirFlip = 0;
EventoMatarAoSairVeiculo = 0;
SendClientMessage(playerid,COLOUR_INFORMACAO,"[INFO]: Evento configurado para [EventoTipoCarros]! Agora digite /criarevento");
return 1;}

if(strcmp("/eventoarmas", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOARMAS");
if(EventoDesarmar == 0){
EventoDesarmar = 1;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players virão para o evento desarmados.");
}else{
EventoDesarmar = 0;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players virão para o evento normalmente com suas armas.");}
return 1;}

if(strcmp("/eventoteles", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOTELES");
if(EventoProibirTele == false){
EventoProibirTele = true;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players não poderão se teleportar quando estiverem no evento.");
}else{
EventoProibirTele = false;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players poderão se teleportar quando estiverem no evento.");}
return 1;}

if(strcmp("/altimetro", cmdtext, true) == 0 || strcmp("/alt", cmdtext, true) == 0) {
if(Altimetro[playerid] == false){
DesligarMonitores(playerid);
Altimetro[playerid] = true;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Altímetro ativado! Para desativar digite novamente: /ALT");
GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~CARREGANDO...",3000,3);
}else{
Altimetro[playerid] = false;
GameTextForPlayer(playerid," ",1000,3);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Altímetro desativado!");}
return 1;}

if(strcmp("/arj", cmdtext, true) == 0 || strcmp("/antirojao", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[8]);
if(AntiRojao[playerid] == false){
AntiRojao[playerid] = true;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Anti-Rojão ativado!");
}else{
AntiRojao[playerid] = false;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Anti-Rojão desativado!");}
return 1;}

if(strcmp("/mecanica", cmdtext, true) == 0 || strcmp("/mec", cmdtext, true) == 0) {
if(Mecanica[playerid] == false){
DesligarMonitores(playerid);
Mecanica[playerid] = true;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Monitor de mecânica ativado! Para desativar digite novamente: /MEC");
GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~CARREGANDO...",3000,3);
}else{
Mecanica[playerid] = false;
GameTextForPlayer(playerid," ",1000,3);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Monitor de mecânica desativado!");}
return 1;}

if(strcmp("/eventokitrun", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOKITRUN");
if(EventoKitRun == false){
EventoKitRun = true;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players receberão um Kit Run ao entrarem no evento.");
}else{
EventoKitRun = false;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players não receberão um Kit Run ao entrarem no evento.");}
return 1;}

if(strcmp("/eventokitwalk", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOKITWALK");
if(EventoKitWalk == false){
EventoKitWalk = true;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players receberão um Kit Walk ao entrarem no evento.");
}else{
EventoKitWalk = false;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players não receberão um Kit Walk ao entrarem no evento.");}
return 1;}

if(strcmp("/eventoacef", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOACEF");
if(EventoACEF == false){
EventoACEF = true;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players poderão usar o /AC e /EFEITOS no evento");
}else{
EventoACEF = false;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players não poderão usar o /AC e /EFEITOS no evento");}
return 1;}

if(strcmp("/eventorojao", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOROJAO");
if(EventoRojao == false){
EventoRojao = true;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players poderão soltar rojões nos eventos");
}else{
EventoRojao = false;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players não poderão soltar rojões nos eventos");}
return 1;}

if(strcmp("/EventoSemDanos", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOSEMDANOS");
if(EventoSemDanos == false){
EventoSemDanos = true;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players que tentarem bater/matar no evento serão mortos");
}else{
EventoSemDanos = false;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players poderão bater/matar no evento sem serem mortos");}
return 1;}

if(strcmp("/EventoRecarregarLife", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTORECARREGARLIFE");
if(EventoRecarregarLife == false){
EventoRecarregarLife = true;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players que matarem no evento terão o life ou colete restaurados");
}else{
EventoRecarregarLife = false;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players que matarem no evento não terão o life ou colete restaurados");}
return 1;}

if(strcmp("/EventoSPA", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOSPA");
if(EventoSPA == false){
EventoSPA = true;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players nascerão em spawns aleatórios próximos ao local marcado do evento");
}else{
EventoSPA = false;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players nascerão normalmente no local marcado do evento");}
return 1;}

if(strcmp("/EventoOHK", cmdtext, true) == 0) {
if(EventoOHK == false){
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOOHK");
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
EventoOHK = true;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players no evento matarão com um hit com qualquer arma");
}else{
EventoOHK = false;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players no evento não matarão com um hit com qualquer arma");}
return 1;}

if(strcmp("/arenasnp2", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(SNP2Liberado == false){
SNP2Liberado = true;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: A arena SNP2 está aberta! Será fechada automaticamente em 15 minutos.");
KillTimer(TimerSNP2);
TimerSNP2 = SetTimer("FecharSNP2",900000, 0);
}else{
KillTimer(TimerSNP2);
SNP2Liberado = false;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: A arena SNP2 está fechada!");}
return 1;}

if(strcmp("/eventodarlife", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTODARLIFE");
if(EventoDarLife == 0){
EventoDarLife = 1;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players irão para o evento com o life cheio.");
}else{
EventoDarLife = 0;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players irão para o evento com o life padrão.");}
return 1;}

if(strcmp("/eventodarcolete", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTODARCOLETE");
if(EventoDarColete == 0){
EventoDarColete = 1;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players irão para o evento com o colete cheio.");
}else{
EventoDarColete = 0;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players irão para o evento sem colete.");}
return 1;}

if(strcmp("/eventodarspeed", cmdtext, true) == 0) {
EventoDarSpeed = 1;
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTODARSPEED");
if(StuntSuperSpeed[playerid] == false){
ProgramarAntiFlood(playerid);
StuntSuperSpeed[playerid] = true;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]:  {FF0000}Stunt Super Speed ativado no evento!");
}else{
StuntSuperSpeed[playerid] = false;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]:  {FF0000}Stunt Super Speed bloqueado no evento!");
EventoDarSpeed = 0;
}
return 1;}

if(strcmp(cmd, "/eventodararma", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTODARARMA");
tmp = strtok(cmdtext, idx);new weap;
if(!strlen(tmp)){
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Nenhuma arma será dada no evento.");
EventoDarArmaID = 0;
return 1;}
if(!IsNumeric(tmp)) weap = GetWeaponIDFromName(tmp); else weap = strval(tmp);
if(weap == 43||weap == 44||weap == 45||weap == 36||weap == 37 ||weap == 18||weap == 38||weap == 35){
SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: ID de weapon ilegal para player");
return 1;}
if(!IsValidWeapon(weap)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: ID de arma inválida.");
new WeapName[32],str_out[128];
GetWeaponName(weap, WeapName, sizeof(WeapName));
EventoDarArmaID = weap;
format(str_out,sizeof(str_out),"[INFO]: A seguinte arma será dada no evento: %s",WeapName);
SendClientMessage(playerid, COLOUR_INFORMACAO,str_out);
SendClientMessage(playerid, COLOUR_INFORMACAO,"[INFO]: Se quiser usar só esta arma, configure /eventoarmas");
return 1;}

if(strcmp(cmd, "/eventodarveiculo", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTDARVEICULO");
tmp = strtok(cmdtext, idx);new car,str_out[128];
if(!strlen(tmp)){
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Nenhum veículo será dado no evento.");
EventoDarVeiculoID = 0;
return 1;}
if(!IsNumeric(tmp)) car = GetVehicleModelIDFromName(tmp); else car = strval(tmp);
if(car < 400 || car > 611) return  SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Modelo invalido.");
if(car == 520 ||car == 432||car == 425 ||car == 447||car == 464 ||car == 465) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Modelo ilegal.");
EventoDarVeiculoID = car;
format(str_out,sizeof(str_out),"[INFO]: O seguinte veículo será dado no evento: %s",VehicleNames[car-400]);
SendClientMessage(playerid, COLOUR_INFORMACAO,str_out);
SendClientMessage(playerid, COLOUR_INFORMACAO,"[INFO]: Se quiser usar só este veículo, configure /eventoveiculos e /eventocs");
return 1;}

if(strcmp("/eventogranadas", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOGRANADAS");
if(EventoGranadas == 0){
EventoGranadas = 1;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players virão para o evento com suas granadas.");
}else{
EventoGranadas = 0;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players virão para o evento sem granadas.");}
return 1;}

if(strcmp("/eventocarregar", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOCARREGAR");
if(EventoCarregar == 0){
EventoCarregar = 1;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os objetos serão pré-carregados no evento.");
}else{
EventoCarregar = 0;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os objetos não serão pré-carregados no evento.");}
return 1;}

if(strcmp("/eventoveiculos", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOVEICULOS");
if(EventoVeiculos == 0){
EventoVeiculos = 1;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players virão para o evento com seus veículos.");
}else{
EventoVeiculos = 0;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players virão para o evento a pé.");}
return 1;}

if(strcmp("/eventocs", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOCS");
if(EventoProibirCS == 0){
EventoProibirCS = 1;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players não poderão usar o /C e /CS no evento.");
}else{
EventoProibirCS = 0;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players poderão normalmente usar o /C e /CS no evento.");}
return 1;}

if(strcmp("/eventogc", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOGC");
if(EventoProibirGC == 0){
EventoProibirGC = 1;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: O comando /GC ficará desativado no evento.");
}else{
EventoProibirGC = 0;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: O comando /GC ficará ativado no evento.");}
return 1;}

if(strcmp("/eventonocarro", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTONOCARRO");
if(EventoMatarAoSairVeiculo == 0){
EventoMatarAoSairVeiculo = 1;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players serão mortos ao tentarem sair de seus veículos.");
}else{
EventoMatarAoSairVeiculo = 0;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Os players não serão mortos ao tentarem sair de seus veículos.");}
return 1;}

if(strcmp("/eventoflip", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOFLIP");
if(EventoProibirFlip == 0){
EventoProibirFlip = 1;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: O comando /FLIP ficará desativado no evento.");
}else{
EventoProibirFlip = 0;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: O comando /FLIP ficará ativado no evento.");}
return 1;}

if(strcmp("/eventofechar", cmdtext, true) == 0 || strcmp("/eventoliberar", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOFECHAR");
if(EventoPausado == 0){
EventoPausado = 1;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: O evento esta fechado, ativo porém com o teleporte desativado");
if(EventoSkyFall == true){
    DestroyObject(SKYFALL);
}
if(EventoCorridaCC == true){
    DestroyObject(CorridaCC);
}
if(EventoCorridaLV == true){
    DestroyObject(CorridaLV);
}
}else{
EventoPausado = 0;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: O evento esta liberado para os players entrarem!");}
return 1;}

if(strcmp("/criarevento", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(EventoAtivo == 0){
GetPlayerPos(playerid, evento_x, evento_y, evento_z);
evento_vw = GetPlayerVirtualWorld(playerid);
evento_in = GetPlayerInterior(playerid);
if(IsPlayerInAnyVehicle(playerid)){
GetVehicleZAngle(GetPlayerVehicleID(playerid),evento_f);
}else{GetPlayerFacingAngle(playerid, evento_f);}
EventoAtivo = 1;EventoAdminID = playerid;EventoPausado = 1;
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) EventoOHK = false;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Evento ativado. Digite /eventoliberar para liberá-lo! - /eventonome para nomear!");
}else{
EventoAtivo = 0;EventoAdminID = -1;
EventoNome = "";
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Evento desativado, quem está nele será respawnado.");
for(new i; i < GetMaxPlayers(); i++){
if(IsPlayerConnected(i)){
if(NoEvento[i] == 1) {SpawnPlayer(i);GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~r~EVENTO ENCERRADO!", 5000, 5);}}}
}
return 1;}


if(strcmp("/eventopronto", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
ShowPlayerDialog(playerid,EventoProntoDialog,DIALOG_STYLE_LIST,"Escolha o evento preferido:","Esconde Esconde (Motel LS)\nEsconde Esconde (MDLS)\nEsconde Esconde (Crack factory)\nSkyfall\nMorto Vivo (Area 51)\nSurf no Aviao (AEROLS)\nCorrida (LV)\nCorrida (CC)","Selecionar","Voltar");
return 1;}

if(strcmp(cmd, "/pm", true) == 0) {
return 1;}

if(strcmp(cmd, "/christine", true) == 0 || strcmp(cmd, "/ch", true) == 0){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não é o dono do server.");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
CriarVeiculoParaPlayer(playerid, 576); // VEICULO TORNADO
ChangeVehicleColor(GetPlayerVehicleID(playerid), 0, 0); // COR
AddVehicleComponent(GetPlayerVehicleID(playerid),1087); // HIDRAULICA
AddVehicleComponent(GetPlayerVehicleID(playerid),1096); // RODA AHAB*/
AddVehicleComponent(GetPlayerVehicleID(playerid),1008); // NOS
AddVehicleComponent(GetPlayerVehicleID(playerid),1082); // RODA
AddVehicleComponent(GetPlayerVehicleID(playerid),1137); // CROMO LATERAL
AddVehicleComponent(GetPlayerVehicleID(playerid),1135); // ESCAPE
AddVehicleComponent(GetPlayerVehicleID(playerid),1193); // PARACHOQUE TRASEIRO
AddVehicleComponent(GetPlayerVehicleID(playerid),1191); // PARACHOQUE DIANTEIRO
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Ta aí chefe, seu TORNADO!");
return 1;}

if(strcmp(cmd, "/hrancher", true) == 0 || strcmp(cmd, "/ch2", true) == 0){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não é o dono do server.");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);

CriarVeiculoParaPlayer(playerid, 490); // VEICULO RANCHER
ChangeVehicleColor(GetPlayerVehicleID(playerid), 0, 0); // COR PRETA
AddVehicleComponent(GetPlayerVehicleID(playerid),1008); // NOS
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Ta aí chefe, sua Rancher!");
return 1;}

if(strcmp(cmdtext,"/contador",true) == 0){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(CountStage ==0){
GetPlayerName(playerid, pName, sizeof(pName));
format(string, sizeof(string), "[ESPECIAL]: %s iniciou a contagem.", pName);
timer = SetTimer("countdown",1000,1);
CountStage = 3;
if(Locality == 1){
GetPlayerPos(playerid, ccX, ccY, ccZ);
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){
GetPlayerPos(i, ccX2, ccY2, ccZ2);
dist = Distance(ccX, ccY, ccZ, ccX2, ccY2, ccZ2);
if(dist <= FREEZEZONE){
SendClientMessage(i, COLOUR_PINK, string);
GameTextForPlayer(i,"~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~-~y~ 3 ~g~-",1000,3);
if(Freeze == 1){
Frozen[i] = 1;
TogglePlayerControllable(i,0);}
else Frozen[i] = 2;}}}}
else if(Locality == 0){
SendClientMessageToAll(COLOUR_PINK, string);
GameTextForAll("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~-~y~ 3 ~g~-",1000,3);
if(Freeze == 1) ToggleAllControllable(0);}}
else SendClientMessage(playerid, COLOUR_PINK, "O contador esta ocupado.");
return 1;}

if (strcmp("/toglocal", cmdtext, true, 7) == 0){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(CountStage == 0){
if(Locality == 0) Locality = 1, SendClientMessage(playerid, COLOUR_PINK, "Contador local ativado");
else Locality = 0, SendClientMessage(playerid, COLOUR_PINK, "Contador local desativado");}
else GameTextForPlayer(playerid, "Aguarde... Contador em progresso", 3000, 3);
return 1;}

if (strcmp("/togfreeze", cmdtext, true) == 0){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(CountStage == 0){
if(Freeze == 0) Freeze = 1, SendClientMessage(playerid, COLOUR_PINK, "Travar ativado");
else Freeze = 0, SendClientMessage(playerid, COLOUR_PINK, "Travar desativado");}
else GameTextForPlayer(playerid, "Aguarde... Contador em progresso", 3000, 3);
return 1;}

if(strcmp(cmd, "/lutas", true) == 0 || strcmp(cmd, "/academia", true) == 0 || strcmp(cmd, "/estilos", true) == 0){
if(!IsPlayerSpawned(playerid)){return 1;}
if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair do veículo antes");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(NoEvento[playerid] == 1 && EventoDesarmar == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está em um evento. Para sair: /sair");

ShowPlayerDialog(playerid,991,DIALOG_STYLE_LIST,"Você está no menu academia! Escolha um estilo de luta:","Lutador Normal\nLutador Boxe\nLutador Kung Fu\nLutador KneeHead\nLutador GrabKick\nLutador ElBow","Selecionar","Voltar");
return 1;}

if(strcmp(cmd, "/meutempo", true) == 0 || strcmp(cmd, "/mt", true) == 0 || strcmp(cmd, "/meuclima", true) == 0){
if(!IsPlayerSpawned(playerid)){return 1;}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(XuxaPC[playerid] == 1){SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você precisa desabilitar o modo lag baixo: /SL"); return 1;}
ShowPlayerDialog(playerid,999,DIALOG_STYLE_LIST,"Escolha um clima/tempo:","Clima bom (padrão/normal)\nTempo limpo\nClaro\nNublado\nChuvoso\nNevoeiro\nTemp. Areia\nQuente (aumenta o lag)\nFraca visibilidade (diminui o lag)\nBoa visibilidade (aumenta o lag)","Selecionar","Voltar");
return 1;}

if(strcmp(cmd, "/anims", true) == 0 || strcmp(cmd, "/acoes", true) == 0 || strcmp(cmd, "/festa", true) == 0){
if(!IsPlayerSpawned(playerid)){return 1;}
if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair do veículo antes");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
ShowPlayerDialog(playerid,992,DIALOG_STYLE_LIST,"Escolha uma ação especial:","Dançar 1\nDançar 2\nDançar 3\nDançar 4\nMãos para cima\nLigar celular\nDesligar celular\nBeber cerveja\nFumar cigarro\nBeber vinho\nBeber refrigerante","Selecionar","Voltar");
return 1;}

if(strcmp(cmd, "/autotunar", true) == 0 || strcmp(cmd, "/at", true) == 0){
if(!IsPlayerSpawned(playerid)){return 1;}
if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não está em um veículo como motorista.");
AutoTune(GetPlayerVehicleID(playerid));
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Tuning automático aplicado! Digite /AT novamente se não gostar...");
return 1;}

if (strcmp("/godcar", cmdtext, true) == 0 || strcmp("/gc", cmdtext, true) == 0 || strcmp("/godc", cmdtext, true) == 0){
if(!IsPlayerSpawned(playerid)){return 1;}
if(Derby[playerid] != 0) return SendClientMessage(playerid,COLOUR_ERRO, "[ERRO]: Voce não pode usar GODCAR na arena DERBY!");
if(ArenaTipo[playerid] == 69) return SendClientMessage(playerid,COLOUR_ERRO, "[ERRO]: Voce não pode usar GODCAR na arena!");
if(NoEvento[playerid] == 1 && EventoProibirGC == 1 && EventoAtivo == 1){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não pode usar o /GC neste evento. (Sair do evento: /sair)");}
if(GodCarOn[playerid] == 0){
GodCarOn[playerid] = 1;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: GOD-CAR ATIVADO!");
}else{
GodCarOn[playerid] = 0;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: GOD-CAR DESATIVADO!");
}return 1;}

if (strcmp("/nocap", cmdtext, true) == 0 || strcmp("/cap", cmdtext, true) == 0 || strcmp("/nocap", cmdtext, true) == 0){
if(!IsPlayerSpawned(playerid)){return 1;}
if(Capacete[playerid] == false){
Capacete[playerid] = true;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Uso de capacete ativado!");
}else{
Capacete[playerid] = false;
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Uso de capacete desativado!");
}return 1;}

if( strcmp("/semlag", cmdtext, true) == 0 || strcmp("/sl", cmdtext, true) == 0){
if(!IsPlayerSpawned(playerid)){return 1;}
if(XuxaPC[playerid] == 0){
XuxaPC[playerid] = 1;
SetPlayerWeather(playerid, 6);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Modo lag baixo ativado!");
new FPS = GetPVarInt(playerid,"PVarFPS");
new PING = GetPlayerPing(playerid);
new avalPING[11];
if(PING < 150) avalPING = "Excelente";
if(PING >= 150) avalPING = "Muito boa";
if(PING >= 200) avalPING = "Boa";
if(PING >= 220) avalPING = "Normal";
if(PING >= 300) avalPING = "Ruim";
if(PING >= 350) avalPING = "Péssima";
new avalFPS[11];
if(FPS >= 0) avalFPS = "Péssimo";
if(FPS >= 15) avalFPS = "Ruim";
if(FPS >= 24) avalFPS = "Normal";
if(FPS >= 35) avalFPS = "Bom";
if(FPS >= 40) avalFPS = "Muito bom";
if(FPS >= 50) avalFPS = "Excelente";
new string2[100];
format(string, sizeof(string), "Seu FPS: %i - Seu PING: %i", FPS,PING);
format(string2, sizeof(string2), "Seu computador: %s - Sua conexão: %s", avalFPS,avalPING);
SendClientMessage(playerid, COLOUR_INFORMACAO, string);
SendClientMessage(playerid, COLOUR_INFORMACAO, string2);
ShowPlayerDialog(playerid,990,DIALOG_STYLE_MSGBOX,"Modo Lag Baixo","Ativado! Para melhorar o desempenho, digite o comando:\n\n/fpslimit 100\n\nE também tente configurar o nível da\ndraw-distance ao valor mínimo dentro das\nopções avançadas de vídeo do jogo\n\nEste modo não influencia em seu ping\nEste modo apenas ameniza o Lag de PC (Ganhe até 5 FPS)","OK","Cancelar");
}else{
XuxaPC[playerid] = 0;
SetPlayerWeather(playerid, Weather[playerid]);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Clima restaurado!");
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Modo lag baixo desativado!");
}return 1;}

if(strcmp(cmd, "/carro", true) == 0 || strcmp(cmd, "/c", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}

if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não pode usar este comando com pouca vida. Tente: /CS");

if(GetPlayerInterior(playerid) != 0){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2){
SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está dentro de um interior.");return 1;}}

if(CallRemoteFunction("LocalInvalidoParaCS","i",playerid) == 1){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2){
SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Proibido criar veículos neste local");return 1;}}

if(NoEvento[playerid] == 1 && EventoProibirCS == 1 && EventoAtivo == 1){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não pode fazer veículos neste evento. (Sair do evento: /sair)");}
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você já tem um veículo!");}
CriarVeiculoParaPlayer(playerid, 411);

new roda=random(12);
switch(roda){
case 0:AddVehicleComponent(veiculo[playerid], 1073);
case 1:AddVehicleComponent(veiculo[playerid], 1074);
case 2:AddVehicleComponent(veiculo[playerid], 1075);
case 3:AddVehicleComponent(veiculo[playerid], 1076);
case 4:AddVehicleComponent(veiculo[playerid], 1077);
case 5:AddVehicleComponent(veiculo[playerid], 1078);
case 6:AddVehicleComponent(veiculo[playerid], 1079);
case 7:AddVehicleComponent(veiculo[playerid], 1080);
case 8:AddVehicleComponent(veiculo[playerid], 1081);
case 9:AddVehicleComponent(veiculo[playerid], 1082);
case 10:AddVehicleComponent(veiculo[playerid], 1083);
case 11:AddVehicleComponent(veiculo[playerid], 1084);
case 12:AddVehicleComponent(veiculo[playerid], 1085);}
AddVehicleComponent(veiculo[playerid], 1086);
AddVehicleComponent(veiculo[playerid], 1087);
SendClientMessage(playerid, COLOUR_DICA,"[INFO]: Você pode fazer qualquer veículo: /CS");
return 1;}

if(strcmp(cmd, "/moto", true) == 0 || strcmp(cmd, "/m", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(CallRemoteFunction("LocalInvalidoParaCS","i",playerid) == 1){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2){
SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Proibido criar veículos neste local");return 1;}}
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(NoEvento[playerid] == 1 && EventoProibirCS == 1 && EventoAtivo == 1){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não pode fazer veículos neste evento. (Sair do evento: /sair)");}
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você já tem um veículo!");}
CriarVeiculoParaPlayer(playerid, 522);
SendClientMessage(playerid, COLOUR_DICA,"[INFO]: Você pode fazer qualquer veículo: /CS");
return 1;}

if(strcmp(cmd, "/vm", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
new veiculostr[100],car;
veiculostr = strtok(cmdtext, idx);
if(!strlen(veiculostr)) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Modelo não especificado. (EX: /vm infernus)");
if(IsNumeric(veiculostr)) return SendClientMessage(playerid, COLOUR_AVISO, "[AVISO]: Digite um nome de modelo, não número!");
car = GetVehicleModelIDFromName(veiculostr);
if(car < 400 || car > 611) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Modelo inválido");
if(CallRemoteFunction("LocalInvalidoParaCS","i",playerid) == 1){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2){
SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Proibido criar veículos neste local");return 1;}}
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(NoEvento[playerid] == 1 && EventoProibirCS == 1 && EventoAtivo == 1){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não pode fazer veículos neste evento. (Sair do evento: /sair)");}
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você já tem um veículo!");}
CriarVeiculoParaPlayer(playerid, car);
return 1;}

if(strcmp(cmd, "/750", true) == 0 || strcmp(cmd, "/freeway", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(CallRemoteFunction("LocalInvalidoParaCS","i",playerid) == 1){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2){
SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Proibido criar veículos neste local");return 1;}}
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(NoEvento[playerid] == 1 && EventoProibirCS == 1 && EventoAtivo == 1){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não pode fazer veículos neste evento. (Sair do evento: /sair)");}
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você já tem um veículo!");}
CriarVeiculoParaPlayer(playerid, 463);
ChangeVehicleColor(GetPlayerVehicleID(playerid), 0, 0); // COR
SendClientMessage(playerid, COLOUR_DICA,"[INFO]: Você pode fazer qualquer veículo: /CS");
return 1;}

if(strcmp(cmdtext, "/sair", true) == 0){
if(DuelArena[playerid] == true){
SendClientMessage(playerid, COLOUR_ERRO,"[ERRO]: Utilize /SAIRX1W para sair desta arena!");
return 1;
}
if(Derby[playerid] == 1 && Arena[playerid] == 1){
	if(TemCarroPerto(playerid, 1.0)){
        SendClientMessage(playerid,COLOUR_ERRO, "[ERRO]: Voce nao pode usar /sair proximo ou dentro de um veiculo!");
	}else{
		Derby[playerid]= 0;
		Arena[playerid] = 0;
		SetPlayerHealth(playerid,0.0);
	}
	return 1;
}
if(Arena[playerid] == 1 || Arena2[playerid] == 1 && DuelArena[playerid] == false){
if(!IsPlayerSpawned(playerid)){return 1;}
//SAIR NO A/D
if(AAD_Vai[playerid] == 1 && AAD_EmProgresso == 1){
SetPlayerColor(playerid, AAD_OldPlayerColor[playerid]);
AAD_Vai[playerid] = 0;
AAD_Team[playerid] = 0;
DisablePlayerCheckpoint(playerid);
SetPlayerHealth(playerid,0.0);
return 1;}

//SAIR DO GTA V PVC
if(PVC_Vai[playerid] == 1 && PVC_EmProgresso == 1){
SetPlayerColor(playerid, PVC_OldPlayerColor[playerid]);
PVC_Vai[playerid] = 0;
PVC_Team[playerid] = 0;
PVC_TeamBkp[playerid] = 0;
PVC_TeamA[playerid] = false;
PVC_TeamB[playerid] = false;
DisablePlayerCheckpoint(playerid);
SetPlayerHealth(playerid,0.0);
return 1;}

//SAIR DO PL
if(PL_Vai[playerid] == 1 && PL_EmProgresso == 1){
SetPlayerColor(playerid, PL_OldPlayerColor[playerid]);
PL_Vai[playerid] = 0;
PL_Team[playerid] = 0;
PL_PlayerCD[playerid] = 0;
DisablePlayerCheckpoint(playerid);
SetPlayerHealth(playerid,0.0);
return 1;}

//SAIR NAS OUTRAS ARENAS
if(ArenaKills[playerid] >= 3 || ArenaKills2[playerid] >= 3){
new Float:Armour;GetPlayerArmour(playerid, Float:Armour);if(Armour >= 1){
SpawnPlayer(playerid);return 1;}}
SetPlayerHealth(playerid,0.0);return 1;}

if(NoEvento[playerid] == 1 && EventoAtivo == 1){
if(LifeBaixo(playerid)){
SetPlayerHealth(playerid,0.0);
}else{
SpawnPlayer(playerid);}
return 1;
}
return 1;}

if(strcmp(cmd, "/cerveja", true) == 0){
SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_BEER);
return 1;}

if(strcmp(cmd, "/arrumarx1", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 3) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
SendClientMessage(playerid,COLOUR_BRANCO,"Consertando X1...");
X1CLOSED = 1;
X1WCLOSED = 1;
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i))
{
if(Arena[i] == 1){if(ArenaTipo[i] == 3){SetPlayerHealth(i,0.0);}}
if(Arena[i] == 1){if(ArenaTipo[i] == 8){SetPlayerHealth(i,0.0);}}
}}
SetTimerEx("ResetX1",5000, 0, "i" ,playerid);
return 1;}

if (strcmp("/carros", cmdtext, true) == 0 || strcmp("/cs", cmdtext, true) == 0 || strcmp("/estacionamento", cmdtext, true) == 0  || strcmp("/v", cmdtext, true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você já tem um veículo!");}
if(CallRemoteFunction("LocalInvalidoParaCS","i",playerid) == 1){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2){
SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Proibido criar veículos neste local");return 1;}}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(NoEvento[playerid] == 1 && EventoProibirCS == 1 && EventoAtivo == 1){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não pode fazer veículos neste evento. (Sair do evento: /sair)");}
new allvehicles[] = "1\tAvioes\n2\tHelicopteros\n3\tMotos\n4\tConvesiveis\n5\tIndustriais\n6\tLowriders\n7\tOffRoad\n8\tServiços Publicos\n9\tSaloons\n10\tEsportivos\n11\tPeruas\n12\tBarcos\n13\tVeiculos Unicos\n14\tVeiculos RC\n15\tTrailers";
ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST,"Lista de Veiculos:",allvehicles,"Selecionar","Voltar");
return 1;}

if(strcmp(cmdtext, "/paraquedas", true) == 0){
if(!IsPlayerSpawned(playerid)){return 1;}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
GivePlayerWeapon(playerid, 46, 1);
SendClientMessage(playerid, COLOUR_BRANCO,"[INFO]: Paraquedas fornecido.");return 1;}

if(strcmp(cmd, "/KITS", true) == 0 || strcmp(cmd, "/ARMAS", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
MostrarListaCompras(playerid);
return 1;}

if(strcmp(cmd, "/kitwalk", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está em um evento. Para sair: /sair");
if(CallRemoteFunction("GetPlayerCash", "i", playerid) < 20000) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não possui dinheiro o suficiente. Necessário: $20000");
CallRemoteFunction("GivePlayerCash", "ii", playerid, -20000);
GivePlayerWeapon(playerid, 24, 300);
GivePlayerWeapon(playerid, 25, 300);
GivePlayerWeapon(playerid, 31, 300);
GivePlayerWeapon(playerid, 34, 300);
GivePlayerWeapon(playerid, 29, 300);
SendClientMessage(playerid, COLOUR_AVISO, "");
SendClientMessage(playerid, COLOUR_INFORMACAO, "Você comprou um kit com armas WALK por $20000");
SendClientMessage(playerid, COLOUR_INFORMACAO, "O kit será válido até você morrer ou entrar em uma ARENA DM.");
SendClientMessage(playerid, COLOUR_AVISO, "");
return 1;}

if(strcmp(cmd, "/kitvip", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) >= 1){
	if(!IsPlayerSpawned(playerid)){return 1;}
	if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
	if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
	if(NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está em um evento. Para sair: /sair");
	GivePlayerWeapon(playerid, 3, 999);
	GivePlayerWeapon(playerid, 16, 999);
	GivePlayerWeapon(playerid, 26, 999);
	GivePlayerWeapon(playerid, 31, 999);
	GivePlayerWeapon(playerid, 34, 999);
	GivePlayerWeapon(playerid, 28, 999);
	GivePlayerWeapon(playerid, 41, 999);
	GivePlayerWeapon(playerid, 24, 999);
	SendClientMessage(playerid, COLOUR_AVISO, "");
	SendClientMessage(playerid, COLOUR_INFORMACAO, "Você pegou o KITVIP!");
	SendClientMessage(playerid, COLOUR_INFORMACAO, "O kit vip será válido até você morrer ou entrar em uma ARENA DM.");
	SendClientMessage(playerid, COLOUR_AVISO, "");
}else{
	SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não é um vip! Se preferir adquira já o seu {00FF15}( /planovip ) ");
}
return 1;}


if(strcmp(cmd, "/TXOFF", true) == 0) {
Txverifica[playerid] = 0;
TextDrawHideForPlayer(playerid, Textdraw8);
TextDrawHideForPlayer(playerid, TxDNotificador);
TextDrawHideForPlayer(playerid, Textdraw3);
TextDrawHideForPlayer(playerid, Textdraw10);
TextDrawHideForPlayer(playerid,Status[playerid]);
SendClientMessage(playerid, COLOUR_INFORMACAO, "{00FF15}[INFO]: Voce desativou os TextDraw da tela. Para ativar novamente /TXON!");
return 1;}

if(strcmp(cmd, "/TXON", true) == 0) {
Txverifica[playerid] = 1;
TextDrawShowForPlayer(playerid, Textdraw8);
TextDrawShowForPlayer(playerid, TxDNotificador);
TextDrawShowForPlayer(playerid, Textdraw3);
TextDrawShowForPlayer(playerid, Textdraw10);
TextDrawShowForPlayer(playerid,Status[playerid]);
SendClientMessage(playerid, COLOUR_INFORMACAO, "{00FF15}[INFO]: Voce ativou os TextDraw da tela! Para desativar novamente /TXOFF!");
return 1;}

if(strcmp(cmd, "/kittop", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está em um evento. Para sair: /sair");
if(CallRemoteFunction("GetPlayerCash", "i", playerid) < 30000) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não possui dinheiro o suficiente. Necessário: $20000");
CallRemoteFunction("GivePlayerCash", "ii", playerid, -30000);
GivePlayerWeapon(playerid, 4, 2);
GivePlayerWeapon(playerid, 16, 999);
GivePlayerWeapon(playerid, 24, 999);
GivePlayerWeapon(playerid, 26, 999);
GivePlayerWeapon(playerid, 28, 999);
GivePlayerWeapon(playerid, 31, 999);
GivePlayerWeapon(playerid, 34, 999);
GivePlayerWeapon(playerid, 31, 999);
GivePlayerWeapon(playerid, 41, 999);
GivePlayerWeapon(playerid, 46, 999);
SendClientMessage(playerid, COLOUR_AVISO, "");
SendClientMessage(playerid, COLOUR_INFORMACAO, "Você comprou um kit com armas TOP por $30000");
SendClientMessage(playerid, COLOUR_INFORMACAO, "O kit será válido até você morrer ou entrar em uma ARENA DM.");
SendClientMessage(playerid, COLOUR_AVISO, "");
return 1;}

if(strcmp(cmd, "/kitrun", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está em um evento. Para sair: /sair");
if(CallRemoteFunction("GetPlayerCash", "i", playerid) < 20000) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não possui dinheiro o suficiente. Necessário: $20000");
CallRemoteFunction("GivePlayerCash", "ii", playerid, -20000);
GivePlayerWeapon(playerid, 22, 300);
GivePlayerWeapon(playerid, 28, 300);
GivePlayerWeapon(playerid, 26, 300);
SendClientMessage(playerid, COLOUR_AVISO, "");
SendClientMessage(playerid, COLOUR_INFORMACAO, "Você comprou um kit com armas RUN por $20000");
SendClientMessage(playerid, COLOUR_INFORMACAO, "O kit será válido até você morrer ou entrar em uma ARENA DM.");
SendClientMessage(playerid, COLOUR_AVISO, "");
return 1;}

if(strcmp(cmd, "/kitgranadas", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está em um evento. Para sair: /sair");
if(CallRemoteFunction("GetPlayerCash", "i", playerid) < 60000) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não possui dinheiro o suficiente. Necessário: $50000");
CallRemoteFunction("GivePlayerCash", "ii", playerid, -50000);
GivePlayerWeapon(playerid, 16, 200);
SendClientMessage(playerid, COLOUR_AVISO, "");
SendClientMessage(playerid, COLOUR_INFORMACAO, "Você comprou um kit com 200 granadas por $50000");
SendClientMessage(playerid, COLOUR_INFORMACAO, "O kit será válido até você morrer ou entrar em uma ARENA DM.");
SendClientMessage(playerid, COLOUR_AVISO, "");
return 1;}

if(strcmp(cmd, "/kitgas", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está em um evento. Para sair: /sair");
if(NoEvento[playerid] == 1 && EventoAtivo == 1 && EventoGranadas == 0)  return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Proibido granadas neste evento");
if(CallRemoteFunction("GetPlayerCash", "i", playerid) < 60000) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não possui dinheiro o suficiente. Necessário: $50000");
CallRemoteFunction("GivePlayerCash", "ii", playerid, -50000);
GivePlayerWeapon(playerid, 17, 200);
SendClientMessage(playerid, COLOUR_AVISO, "");
SendClientMessage(playerid, COLOUR_INFORMACAO, "Você comprou um kit com 200 TearGas por $50000");
SendClientMessage(playerid, COLOUR_INFORMACAO, "O kit será válido até você morrer ou entrar em uma ARENA DM.");
SendClientMessage(playerid, COLOUR_AVISO, "");
return 1;}

if(strcmp(cmd, "/rojao", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(NoEvento[playerid] == 1 && EventoAtivo == 1 && EventoRojao == false) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está em um evento que não permite rojões");
if(CallRemoteFunction("LocalInvalidoParaRojao","i",playerid) == 1) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Proibido soltar rojões por aqui");
//AntiRojao
new Float:px,Float:py, Float:pz;
GetPlayerPos(playerid, px, py, pz);
new bool:AntiRojaoCheck;
AntiRojaoCheck = false;
for(new i; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i)) if(IsPlayerInRangeOfPoint(i, 200.0, px, py, pz)) if(AntiRojao[i] == true) AntiRojaoCheck = true;
if(AntiRojaoCheck == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Alguém nas proximidades está com Anti-Rojão");
//
new VeiculoIlegal = 0;
switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
{
case 592: VeiculoIlegal = 1;
case 577: VeiculoIlegal = 1;
case 511: VeiculoIlegal = 1;
case 512: VeiculoIlegal = 1;
case 593: VeiculoIlegal = 1;
case 520: VeiculoIlegal = 1;
case 553: VeiculoIlegal = 1;
case 476: VeiculoIlegal = 1;
case 519: VeiculoIlegal = 1;
case 460: VeiculoIlegal = 1;
case 513: VeiculoIlegal = 1;
case 548: VeiculoIlegal = 1;
case 425: VeiculoIlegal = 1;
case 417: VeiculoIlegal = 1;
case 487: VeiculoIlegal = 1;
case 488: VeiculoIlegal = 1;
case 497: VeiculoIlegal = 1;
case 563: VeiculoIlegal = 1;
case 447: VeiculoIlegal = 1;
case 469: VeiculoIlegal = 1;
}
if(VeiculoIlegal == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Uso de rojão é proibido de dentro de aeronaves.");
new Float:x, Float:y, Float:z;
GetPlayerPos(playerid, x, y, z);
CreateExplosion(x, y, z+25, 7, 5.0);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Um forte rojão foi detonado 25 metros acima de sua cabeça.");
return 1;}

if(strcmp(cmd, "/trancar", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não está em um veículo como motorista.");
if(GetPlayerVehicleID(playerid) != veiculo[playerid]) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você só pode trancar os veículos que você fazer em /C ou /CS");
if(vtrancado[veiculo[playerid]] == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O veículo ja está trancado.");
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){
if(i != playerid){
SetVehicleParamsForPlayer(veiculo[playerid],i, 0, 1);
vtrancado[veiculo[playerid]] = 1;AutoTrancar[playerid] = 1;}}}
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Veículo Trancado!");
return 1;}

if(strcmp(cmd, "/destrancar", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não está em um veículo como motorista.");
if(GetPlayerVehicleID(playerid) != veiculo[playerid]) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você só pode destrancar os veículos que você fazer em /C ou /CS");
if(vtrancado[veiculo[playerid]] == 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O veículo ja está destrancado.");
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){
if(i != playerid){
SetVehicleParamsForPlayer(veiculo[playerid],i, 0, 0);
vtrancado[veiculo[playerid]] = 0;AutoTrancar[playerid] = 0;}}}
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Veículo Destrancado!");
return 1;}

if(strcmp(cmd, "/tmv", true) == 0 || strcmp(cmd, "/vcar", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(GetPlayerState(playerid)!= PLAYER_STATE_ONFOOT) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você precisa estar a pé para usar este comando");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(NoEvento[playerid] == 1 && EventoProibirCS == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está em um evento. Para sair: /sair");
if(veiculo[playerid] == 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não tem veículo. Digite /C ou CS para fazer um.");
if(CallRemoteFunction("LocalInvalidoParaCS","i",playerid) == 1){if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2){SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Proibido criar veículos neste local");return 1;}}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
//ANTI-TMV
new modelo = GetVehicleModel(veiculo[playerid]);
if(modelo == 592 || modelo == 577 || modelo == 476)
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2)
return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O /TMV não pode trazer seu veículo");
//INTERIORES
if(GetPlayerInterior(playerid) != 0){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2){SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está dentro de um interior.");return 1;}}
//ARRANCAR LADRAO
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){
if(GetPlayerState(i) == PLAYER_STATE_DRIVER){
if(GetPlayerVehicleID(i) == veiculo[playerid]){
if(i != playerid){
new Float:splayerposx, Float:splayerposy, Float:splayerposz;
GetPlayerPos(i, splayerposx, splayerposy, splayerposz);
SetPlayerPos(i,splayerposx, splayerposy, splayerposz+3);SetCameraBehindPlayer(i);
SendClientMessage(i, COLOUR_AVISO, "[AVISO]: Você foi ejetado pelo dono do veículo.");}}}}}
// ----------------
new Float:playerposx, Float:playerposy, Float:playerposz;
GetPlayerPos(playerid, playerposx, playerposy, playerposz);
new Float:Angle;
SetVehicleVirtualWorld(veiculo[playerid], GetPlayerVirtualWorld(playerid));
LinkVehicleToInterior(veiculo[playerid], GetPlayerInterior(playerid));
GetPlayerFacingAngle(playerid,Angle);
SetVehicleZAngle(veiculo[playerid], Angle);
SetVehiclePos(veiculo[playerid], playerposx, playerposy, playerposz);
PutPlayerInVehicle(playerid,veiculo[playerid],0);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Seu veículo foi puxado para você");
KillTimer(TimerMV[playerid]);
return 1;}

if(strcmp(cmd, "/mv", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(GetPlayerState(playerid)!= PLAYER_STATE_ONFOOT) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você precisa estar a pé para usar este comando");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(veiculo[playerid] == 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não tem veículo. Digite /C ou CS para fazer um.");
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2){
if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está em uma área não permitida para veículos.");}
SendClientMessage(playerid, COLOUR_INFORMACAO, "[DICA]: Você pode usar /TMV para puxar seu veículo para onde você está!");
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Localizando seu veículo... Aguarde 10 segundos...");
//TRANCAR
for(new i; i < GetMaxPlayers(); i++){
if(i != playerid){
SetVehicleParamsForPlayer(veiculo[playerid],i, 0, 1);
vtrancado[veiculo[playerid]] = 1;AutoTrancar[playerid] = 1;}}
//ARRANCAR O SUPOSTO LADRÃO DO VEÍCULO
for(new i; i < GetMaxPlayers(); i++){
if(GetPlayerState(i) == PLAYER_STATE_DRIVER && IsPlayerConnected(i)){
if(GetPlayerVehicleID(i) == veiculo[playerid]){
if(i != playerid){
new Float:playerposx, Float:playerposy, Float:playerposz;
GetPlayerPos(i, playerposx, playerposy, playerposz);
SetPlayerPos(i,playerposx, playerposy, playerposz+3);SetCameraBehindPlayer(i);
SendClientMessage(i, COLOUR_AVISO, "[AVISO]: Você foi ejetado pelo dono do veículo.");}}}}
KillTimer(TimerMV[playerid]);
TimerMV[playerid] = SetTimerEx("ColocarPlayerEmSeuVeiculo",10000,0, "i", playerid);
return 1;}

if (strcmp(cmdtext, "/flip", true)==0 || strcmp("/virar", cmdtext, true) == 0 || strcmp("/girar", cmdtext, true) == 0 || strcmp("/flipar", cmdtext, true) == 0 || strcmp("/desvirar", cmdtext, true) == 0 || strcmp("/f", cmdtext, true) == 0 || strcmp("/desvirar", cmdtext, true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(Derby[playerid] != 0) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Voce não pode DESVISAR seu veiculo na arena DERBY.");
if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Voce não esta em um veiculo como motorista.");
if(NoEvento[playerid] == 1 && EventoProibirFlip == 1 && EventoAtivo == 1){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não pode usar o /FLIP neste evento. (Sair do evento: /sair)");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Comando não permitido para este tipo de veículo.");}
new VehicleID, Float:X, Float:Y, Float:Z, Float:Angle; GetPlayerPos(playerid, X, Y, Z); VehicleID = GetPlayerVehicleID(playerid);
GetVehicleZAngle(VehicleID, Angle);	SetVehiclePos(VehicleID, X, Y, Z); SetVehicleZAngle(VehicleID, Angle); SetVehicleHealth(VehicleID,1000.0);
return GameTextForPlayer(playerid,"~G~VEICULO VIRADO!", 3000, 5);}

if (strcmp(cmdtext, "/reparar", true)==0 || strcmp("/consertar", cmdtext, true) == 0 || strcmp("/fix", cmdtext, true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Voce não esta em um veiculo.");
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Comando não permitido para este tipo de veículo.");}
if(NoEvento[playerid] == 1 && EventoProibirGC == 1 && EventoAtivo == 1){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não pode usar o /REPARAR neste evento. (Sair do evento: /sair)");}
Reparar[playerid] = 1;
RepairVehicle(GetPlayerVehicleID(playerid));
return GameTextForPlayer(playerid,"~G~VEICULO CONSERTADO!", 3000, 5);}

if(strcmp(cmdtext, "/KitGay", true) == 0 || strcmp(cmdtext, "/sougay", true) == 0){
if(!IsPlayerSpawned(playerid)){return 1;}
if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(NoEvento[playerid] == 1 && EventoDesarmar == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está em um evento. Para sair: /sair");
if(CallRemoteFunction("GetPlayerCash", "i", playerid) < 24) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não possui dinheiro o suficiente. Necessário: $24");
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
CallRemoteFunction("GivePlayerCash", "ii", playerid, -24);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "[INFO]: %s adquiriu seu kit gay por: $24 ( /KitGay )", pname);
SendClientMessageToAllEx(playerid, 0xFFA5C7FF, string);
Gay[playerid] = true;
GivePlayerWeapon(playerid, 7, 300);
GivePlayerWeapon(playerid, 10, 300);
if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_NONE) SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE4);
if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_ENTER_VEHICLE) SetPlayerSkin(playerid, 252);
SendClientMessage(playerid, COLOUR_AVISO, "");
SendClientMessage(playerid, COLOUR_INFORMACAO, "Você comprou um kit GAY por $24");
SendClientMessage(playerid, COLOUR_INFORMACAO, "O kit será válido até você morrer ou entrar em uma ARENA DM.");
SendClientMessage(playerid, COLOUR_AVISO, "");
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/colete", true) == 0 || strcmp(cmdtext, "/cct", true) == 0 ) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(ccolete[playerid] == 1){SendClientMessage(playerid, 0xFF6F28AA, "{FF0000}[INFO]:{FFFFFF} Você so pode comprar um Colete por Spawn");return 1;}
ccolete[playerid] = 1;
if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "{FF0000}[ERRO]: {FFFFFF}Você deve sair de seu veículo.");}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, "{FF0000}[ERRO]: {FFFFFF}Você está em um evento. Para sair: {FF0000}/sair");
if(CallRemoteFunction("GetPlayerCash", "i", playerid) < 1000) return SendClientMessage(playerid, COLOUR_ERRO, "{FF0000}[ERRO]: {FFFFFF}Você não possui dinheiro o suficiente. Necessário: $100");
CallRemoteFunction("GivePlayerCash", "ii", playerid, -1000);
SetPlayerArmour(playerid, 100);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{00FFA2}%s {FFFFFF}Comprou Colete {CC3361}( /COLETE )", pname);
SendClientMessageToAll(COLOUR_AVISO, string);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/vida", true) == 0 || strcmp(cmdtext, "/vd", true) == 0 ) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(vida[playerid] == 1){SendClientMessage(playerid, 0xFF6F28AA, "{FF0000}[INFO]:{FFFFFF} Você so pode comprar um Vida por Spawn");return 1;}
vida[playerid] = 1;
if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "{FF0000}[ERRO]: {FFFFFF}Você deve sair de seu veículo.");}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, "{FF0000}[ERRO]: {FFFFFF}Você está em um evento. Para sair: {FF0000}/sair");
if(CallRemoteFunction("GetPlayerCash", "i", playerid) < 2000) return SendClientMessage(playerid, COLOUR_ERRO, "{FF0000}[ERRO]: {FFFFFF}Você não possui dinheiro o suficiente. Necessário: $3000");
CallRemoteFunction("GivePlayerCash", "ii", playerid, -2000);
SetPlayerHealth(playerid, 100);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{00FFA2}%s {FFFFFF}Comprou Vida {CC3361}( /VIDA )", pname);
SendClientMessageToAll(COLOUR_AVISO, string);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/avenida", true) == 0){
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para a AVENIDA {CC3361}( /AVENIDA )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
new cartype = GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);
{if(State!=PLAYER_STATE_DRIVER)
{SetPlayerPos(playerid,2057.0847,840.1503,6.7337);SetCameraBehindPlayer(playerid);}
else if(IsPlayerInVehicle(playerid, cartype) == 1)
{SetVehiclePos(cartype,2057.0847,840.1503,15.7337);
SetVehicleZAngle(cartype,1.0333);}
else{SetPlayerPos(playerid,2057.0847,840.1503,6.7337);SetCameraBehindPlayer(playerid);}}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/kill", true) == 0 || strcmp("/morrer", cmdtext, true) == 0 || strcmp("/suicidar", cmdtext, true) == 0){
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está em um local em que é proibido morrer!");
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new Float:vidak;
	GetPlayerHealth(playerid, vidak);
	if(vidak == 100)
		if(TemCarroPerto(playerid, 1.0))return SendClientMessage(playerid,COLOUR_ERRO, "[ERRO]: Voce nao pode usar /kill proximo ou dentro de um veiculo!");
SetPlayerHealth(playerid,0.0);
new message[100];
new pname[30];
GetPlayerName(playerid, pname, sizeof(pname));
format(message, sizeof(message), "{FFFFFF}%s {FF0000}se matou! ( /kill )", pname);
if(IsPlayerSpawned(playerid)){SendClientMessageToAll(COLOUR_BRANCO,message);}
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/rm2", true) == 0){
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para a RAMPA MORTAL 2 {CC3361}( /RM2 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
new cartype = GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);
{if(State!=PLAYER_STATE_DRIVER)
{SetPlayerPos(playerid,2843.0728,-2936.4565,737.5344);SetCameraBehindPlayer(playerid);}
else if(IsPlayerInVehicle(playerid, cartype) == 1)
{SetVehiclePos(cartype,2843.0728,-2936.4565,737.5344);
SetVehicleZAngle(cartype,267.9979);}
else{SetPlayerPos(playerid,2843.0728,-2936.4565,737.5344);SetCameraBehindPlayer(playerid);}}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/DR", true) == 0){
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o DEATH ROAD MAP {CC3361}( /DR )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
new cartype = GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);
{if(State!=PLAYER_STATE_DRIVER)
{SetPlayerPos(playerid,-2931.7991,-828.6174,7.7759);SetCameraBehindPlayer(playerid);}
else if(IsPlayerInVehicle(playerid, cartype) == 1)
{SetVehiclePos(cartype,-2931.7991,-828.6174,7.7759);
SetVehicleZAngle(cartype,1.0333);}
else{SetPlayerPos(playerid,2057.0847,840.1503,6.7337);SetCameraBehindPlayer(playerid);}}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/NRG", true) == 0){
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o PARKOUR de NRG {CC3361}( /NRG )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
new cartype = GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);
{if(State!=PLAYER_STATE_DRIVER)
{SetPlayerPos(playerid,-2245.6714,-1718.3846,480.3323);SetCameraBehindPlayer(playerid);}
else if(IsPlayerInVehicle(playerid, cartype) == 1)
{SetVehiclePos(cartype,-2245.6714,-1718.3846,480.3323);
SetVehicleZAngle(cartype,1.0333);}
else{SetPlayerPos(playerid,2057.0847,840.1503,6.7337);SetCameraBehindPlayer(playerid);}}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/NRG2", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para PARKOUR de NRG2 {CC3361}( /NRG2 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),1052.0026,2913.0547,51.6622);
SetVehicleZAngle(GetPlayerVehicleID(playerid), 358.2260);}else{
SetPlayerPos(playerid,1052.0026,2913.0547,51.6622);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,358.2260);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/NRG3", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para PARKOUR de NRG3 {CC3361}( /NRG3 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),325.3018,-2840.9668,146.5188);
SetVehicleZAngle(GetPlayerVehicleID(playerid), 359.7510);}else{
SetPlayerPos(playerid,325.3018,-2840.9668,146.5188);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,359.7510);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/PK5", true) == 0) {
if(CallRemoteFunction("GetSubsystemStatus","") == 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[4]);
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o PARKOUR 5 {CC3361}( /PK5 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
ResetPlayerWeapons(playerid);
if(IsPlayerInAnyVehicle(playerid)){SendClientMessage(playerid, COLOUR_INFORMACAO, StringTable[5]);}
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-101.0335, -3001.1169, 59.7985);SetCameraBehindPlayer(playerid);Carregar(playerid);
SetVehicleZAngle(GetPlayerVehicleID(playerid), 359.1325);}else{
SetPlayerPos(playerid,-101.0335, -3001.1169, 59.7985);SetCameraBehindPlayer(playerid);Carregar(playerid);
SetPlayerFacingAngle(playerid,359.1325);}
Streamer_Update(playerid);
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/PK", true) == 0) {
if(CallRemoteFunction("GetSubsystemStatus","") == 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[4]);
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o PARKOUR {CC3361}( /PK )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
ResetPlayerWeapons(playerid);
if(IsPlayerInAnyVehicle(playerid)){SendClientMessage(playerid, COLOUR_INFORMACAO, StringTable[5]);}
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),1551.3062,-1253.3381,328.4476);SetCameraBehindPlayer(playerid);Carregar(playerid);
SetVehicleZAngle(GetPlayerVehicleID(playerid), 359.1325);}else{
SetPlayerPos(playerid,1551.3062,-1253.3381,328.4476);SetCameraBehindPlayer(playerid);Carregar(playerid);
SetPlayerFacingAngle(playerid,359.1325);}
Streamer_Update(playerid);
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/PK2", true) == 0){
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o PARKOUR 2 {CC3361}( /PK2 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
new cartype = GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);
{if(State!=PLAYER_STATE_DRIVER)
{SetPlayerPos(playerid,-190.3182,1541.8063,66.6480);SetCameraBehindPlayer(playerid);}
else if(IsPlayerInVehicle(playerid, cartype) == 1)
{SetVehiclePos(cartype,-190.3182,1541.8063,66.6480);
SetVehicleZAngle(cartype,1.0333);}
else{SetPlayerPos(playerid,-190.3182,1541.8063,66.64805);SetCameraBehindPlayer(playerid);}}ProgramarAntiFlood(playerid);return 1;}


if(strcmp(cmdtext, "/PK3", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para PARKOUR 3 {CC3361}( /PK3 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
ResetPlayerWeapons(playerid);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),1170.4441,-2042.4100,433.4133);
SetVehicleZAngle(GetPlayerVehicleID(playerid),186.6221);}else{
SetPlayerPos(playerid,1170.4441,-2042.4100,433.4133);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,186.6221);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);
PlayerPlaySound(playerid, 1133, 0.0, 0.0, 10.0);
return 1;}

if(strcmp(cmdtext, "/PK4", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para PARKOUR 4 {CC3361} ( /PK4 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
ResetPlayerWeapons(playerid);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),1673.6279,-1345.3406,165.7340);
SetVehicleZAngle(GetPlayerVehicleID(playerid),186.6221);}else{
SetPlayerPos(playerid, 1675.8073,-1344.2089,158.4766);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,186.6221);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);
PlayerPlaySound(playerid, 1133, 0.0, 0.0, 10.0);
return 1;}

if(strcmp(cmdtext, "/PK6", true) == 0) {
if(CallRemoteFunction("GetSubsystemStatus","") == 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[4]);
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o PARKOUR 6 {CC3361}( /PK6 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
ResetPlayerWeapons(playerid);
if(IsPlayerInAnyVehicle(playerid)){SendClientMessage(playerid, COLOUR_INFORMACAO, StringTable[5]);}
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-3404.9995, 1569.8923, 18.5673);SetCameraBehindPlayer(playerid);Carregar(playerid);
SetVehicleZAngle(GetPlayerVehicleID(playerid), 359.1325);}else{
SetPlayerPos(playerid,-3404.9995, 1569.8923, 18.5673);SetCameraBehindPlayer(playerid);Carregar(playerid);
SetPlayerFacingAngle(playerid,359.1325);}
Streamer_Update(playerid);
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/WG", true) == 0){
GivePlayerWeapon(playerid,46,1);
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o Wingsuit {CC3361}( /WG )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
new cartype = GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);
{if(State!=PLAYER_STATE_DRIVER)
{SetPlayerPos(playerid,-274.4135,-633.8300,16504.7344);SetCameraBehindPlayer(playerid);}
else if(IsPlayerInVehicle(playerid, cartype) == 1)
{SetVehiclePos(cartype,-274.4135,-633.8300,16504.7344);
SetVehicleZAngle(cartype,1.0333);}
else{SetPlayerPos(playerid,2057.0847,840.1503,6.7337);SetCameraBehindPlayer(playerid);}}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/DROP7", true) == 0){
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o DROP 7 {CC3361}( /DROP7 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
new cartype = GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);
{if(State!=PLAYER_STATE_DRIVER)
{SetPlayerPos(playerid,2481.8835,-1691.2965,789.6312);SetCameraBehindPlayer(playerid);}
else if(IsPlayerInVehicle(playerid, cartype) == 1)
{SetVehiclePos(cartype,2481.8835,-1691.2965,789.6312);
SetVehicleZAngle(cartype,167.1952);}
else{SetPlayerPos(playerid,2481.8835,-1691.2965,789.6312);SetCameraBehindPlayer(playerid);}}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/DROP8", true) == 0){
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o DROP 8 {CC3361}( /DROP8 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
new cartype = GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);
{if(State!=PLAYER_STATE_DRIVER)
{SetPlayerPos(playerid,2926.9045,-649.5533,519.9172);SetCameraBehindPlayer(playerid);}
else if(IsPlayerInVehicle(playerid, cartype) == 1)
{SetVehiclePos(cartype,2926.9045,-649.5533,519.9172);
SetVehicleZAngle(cartype,269.9696);}
else{SetPlayerPos(playerid,2926.9045,-649.5533,519.9172);SetCameraBehindPlayer(playerid);}}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/DROP9", true) == 0){
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o DROP 9 {CC3361}( /DROP9 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
new cartype = GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);
{if(State!=PLAYER_STATE_DRIVER)
{SetPlayerPos(playerid,3894.5930,-2501.6106,1023.8886);SetCameraBehindPlayer(playerid);}
else if(IsPlayerInVehicle(playerid, cartype) == 1)
{SetVehiclePos(cartype,3894.5930,-2501.6106,1023.8886);
SetVehicleZAngle(cartype,90.1380);}
else{SetPlayerPos(playerid,3894.5930,-2501.6106,1023.8886);SetCameraBehindPlayer(playerid);}}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/DROP10", true) == 0){
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o DROP 10 {CC3361}( /DROP10 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
new cartype = GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);
{if(State!=PLAYER_STATE_DRIVER)
{SetPlayerPos(playerid,261.3799,-935.6604,479.7445);SetCameraBehindPlayer(playerid);}
else if(IsPlayerInVehicle(playerid, cartype) == 1)
{SetVehiclePos(cartype,261.3799,-935.6604,479.7445);
SetVehicleZAngle(cartype,270.6197);}
else{SetPlayerPos(playerid,261.3799,-935.6604,479.7445);SetCameraBehindPlayer(playerid);}}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/lasventuras", true) == 0 || strcmp(cmdtext, "/lv", true) == 0 ) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para LAS VENTURAS {CC3361}( /LV )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),2033.8962,1008.0480,10.8203);
SetVehicleZAngle(GetPlayerVehicleID(playerid), 270.3270);}else{
SetPlayerPos(playerid,2033.8962,1008.0480,10.8203);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,270.3270);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(skin[playerid] == 209){
if(strcmp(cmdtext, "/DDR", true) == 0 ) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para a BASE DOS [DDR]", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid), 1786.6172,-1294.9877,13.0521);
SetVehicleZAngle(GetPlayerVehicleID(playerid), -180.0000);}else{
SetPlayerPos(playerid,1786.6172,-1294.9877,13.0521);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,-180.0000);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}
}

if(strcmp(cmdtext, "/clube", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o CLUBE {CC3361}( /CLUBE )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),2494.2261,1540.4420,10.8203);
SetVehicleZAngle(GetPlayerVehicleID(playerid), 270.3270);}else{
SetPlayerPos(playerid,2494.2261,1540.4420,10.8203);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,270.3270);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/ET", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o ESTACIONAMENTO TOPO {CC3361}( /ET )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),2182.1294,760.4775,171.6237);
SetVehicleZAngle(GetPlayerVehicleID(playerid), 1.9277);}else{
SetPlayerPos(playerid,2182.1294,760.4775,171.6237);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,1.9277);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp("/ajudafly", cmdtext, true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,0x66CCFFAA,StringTable[8]);
new ajudafly[1000];
strins(ajudafly,"\n{FFFFFF}Para controlar e subir segure o botao esquerdo do mouse!",strlen(ajudafly));
strins(ajudafly,"\n{FFFFFF}Para descer segure o botao direito do mouse",strlen(ajudafly));
strins(ajudafly,"\n{FFFFFF}Para ir mais rapido segure espaço!",strlen(ajudafly));
strins(ajudafly,"\n{FFFFFF}Para ir mais devagar segure alt!",strlen(ajudafly));
ShowPlayerDialog(playerid,8438, DIALOG_STYLE_MSGBOX, "{00FF00}AJUDA FLY!",ajudafly, "OK", "");
return 1;}

if(strcmp("/fly", cmdtext, true) == 0) {
	if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,0x66CCFFAA,StringTable[8]);
	if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
	if(NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está em um evento. Para sair: /sair");
	if(GetPlayerInterior(playerid) != 0) return StopFly(playerid);
	if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 0) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não tem permissão para isso");
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Fly Ativado Para Saber como usar /ajudafly!");
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Para desativar digite /flyoff!");
	StartFly(playerid);
	return 1;
}
if(strcmp("/flyoff", cmdtext, true) == 0) {
	if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,0x66CCFFAA,StringTable[8]);
	if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
	if(NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está em um evento. Para sair: /sair");
	if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 0) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não tem permissão para isso");
	if(GetPlayerInterior(playerid) != 0) return StopFly(playerid);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Fly foi Desligado!");
	StopFly(playerid);
	return 1;
}

if(strcmp(cmdtext, "/MR", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para a MINI RAMPA {CC3361}( /MR )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),828.6941,-1771.7628,528.1320);
SetVehicleZAngle(GetPlayerVehicleID(playerid), 206.7302);}else{
SetPlayerPos(playerid,804.6752,-1725.7805,524.0944);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,205.8685);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/EC", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o ENCONTRO DE CARROS{CC3361} ( /EC )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-2438.1055, -2788.5359, 3.2468);
SetVehicleZAngle(GetPlayerVehicleID(playerid), -180.0);}else{
SetPlayerPos(playerid,-2438.1055, -2788.5359, 3.2468);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,-180.0);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/HD", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para HARD DROP {CC3361}( /HD )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),3339.7314,1390.4713,707.0564);
SetVehicleZAngle(GetPlayerVehicleID(playerid), 89.6370);}else{
SetPlayerPos(playerid,3339.7314,1390.4713,707.0564);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,84.2102);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/et2", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o ESTACIONAMENTO 2{CC3361}( /ET2 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),2856.3491,1036.9196,336.1661);
SetVehicleZAngle(GetPlayerVehicleID(playerid),180.5224);}else{
SetPlayerPos(playerid,2856.3491,1036.9196,336.1661);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,180.5224);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/CC2", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o CIRCUITO DE CORRIDAS 2{CC3361} ( /CC2 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,7);
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-1402.8070,-250.9425,1043.2693);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,345.8369);
SetCameraBehindPlayer(playerid);
}else{
SetPlayerPos(playerid,-1402.8070,-250.9425,1043.2693);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,345.8369);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);
DerbyDarVeiculoID = 411;
SetTimerEx("CriarVeiculodeEventoParaPlayer",2000,0, "ii", playerid,DerbyDarVeiculoID);
return 1;}

if(strcmp(cmdtext, "/PKSA", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o PARKOUR DE SANCHEZ{CC3361} ( /PKSA )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,14);
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-1465.7937,1563.2341,1052.4166);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,358.5206);
SetCameraBehindPlayer(playerid);
}else{
SetPlayerPos(playerid,-1465.7937,1563.2341,1052.4166);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,358.5206);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);
DerbyDarVeiculoID = 468;
if(DerbyDarVeiculoID != 0) SetTimerEx("CriarVeiculodeEventoParaPlayer",2000,0, "ii", playerid,DerbyDarVeiculoID);
return 1;}

if(strcmp(cmdtext, "/CCM", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o CIRCUITO DE CORRIDA DE MOTO{CC3361} ( /CCM )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,4);
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-1376.1211,-665.3710,1055.6143);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,87.8213);
SetCameraBehindPlayer(playerid);
}else{
SetPlayerPos(playerid,-1376.1211,-665.3710,1055.6143);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,87.8213);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);
DerbyDarVeiculoID = 522;
if(DerbyDarVeiculoID != 0) SetTimerEx("CriarVeiculodeEventoParaPlayer",2000,0, "ii", playerid,DerbyDarVeiculoID);
return 1;}


if(strcmp(cmdtext, "/DERBY", true) == 0 ) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
SetPlayerVirtualWorld(playerid, 547);
Arena[playerid] = 1;
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para a ARENA DERBY {FF0000}( /DERBY )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,15);
StuntSuperSpeed[playerid] = false;
GodCarOn[playerid] = 0;
NoEvento[playerid] = 1;
EventoMatarAoSairDerby[playerid] = 1;
Derby[playerid] = 1;
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
new rand = random(sizeof(DerbyPos));
SetPlayerPos(playerid, DerbyPos[rand][0], DerbyPos[rand][1], DerbyPos[rand][2]);
SetPlayerFacingAngle(playerid,DerbyPos[rand][3]);
DerbyDarVeiculoID = 556;
if(DerbyDarVeiculoID != 0) SetTimerEx("CriarVeiculodeEventoParaPlayer",2000,0, "ii", playerid,DerbyDarVeiculoID);
}else{
new rand = random(sizeof(DerbyPos));
SetPlayerPos(playerid, DerbyPos[rand][0], DerbyPos[rand][1], DerbyPos[rand][2]);
SetPlayerFacingAngle(playerid,DerbyPos[rand][3]);
DerbyDarVeiculoID = 556;
if(DerbyDarVeiculoID != 0) SetTimerEx("CriarVeiculodeEventoParaPlayer",2000,0, "ii", playerid,DerbyDarVeiculoID);
}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/stunt", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o STUNT {CC3361}( /STUNT )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),2057.6597,2182.6731,610.3065);
SetVehicleZAngle(GetPlayerVehicleID(playerid),180.4379);}else{
SetPlayerPos(playerid,2057.6597,2182.6731,610.3065);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,180.4379);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/stuntpro", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o STUNTPRO {CC3361}( /STUNTPRO )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),3088.1194,889.1468,52.0905);
SetVehicleZAngle(GetPlayerVehicleID(playerid),269.4302);}else{
SetPlayerPos(playerid,3088.1194,889.1468,52.0905);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,269.4302);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/stuntpro2", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o STUNTPRO 2 {CC3361}( /STUNTPRO2 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),3784.7576,-3298.2131,8.2562);
SetVehicleZAngle(GetPlayerVehicleID(playerid),180.5932);}else{
SetPlayerPos(playerid,3784.7576,-3298.2131,8.2562);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,180.5932);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/SPU", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o SUPER PULO {CC3361}( /SPU )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),203.9033,3213.4253,294.2944);
SetVehicleZAngle(GetPlayerVehicleID(playerid),269.1169);}else{
SetPlayerPos(playerid,203.9033,3213.4253,294.2944);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,269.1169);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);
return 1;}


if(strcmp(cmdtext, "/BARCO", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o BARCO {CC3361}( /BARCO )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),2898.2910,-2051.2095,3.5480);
SetVehicleZAngle(GetPlayerVehicleID(playerid), 275.0219);}else{
SetPlayerPos(playerid,2898.2910,-2051.2095,3.5480);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,275.0219);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/PS", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para a PISTA MORTAL {CC3361}( /PS )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),1960.9850,-1195.2008,201.0643);
SetVehicleZAngle(GetPlayerVehicleID(playerid), 263.0485);}else{
SetPlayerPos(playerid,1960.9850,-1195.2008,201.0643);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,263.0485);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/CADM", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) <= 3) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO] Você não tem permissão para isso");
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para a CASA dos ADM", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-2886.7827,426.4641,4.9154);
SetVehicleZAngle(GetPlayerVehicleID(playerid), 89.3441);}else{
SetPlayerPos(playerid,-2886.7827,426.4641,4.9154);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,89.3441);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/RM4", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para a RAMPA MORTAL{CC3361}( /RM4 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-4252.5806,473.5434,864.7677);
SetVehicleZAngle(GetPlayerVehicleID(playerid), 267.9357);}else{
SetPlayerPos(playerid,-4252.5806,473.5434,864.7677);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,267.9357);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/LABIRINTO", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
ResetPlayerWeapons(playerid);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,100);
SetPlayerVirtualWorld(playerid, 500);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para o LABIRINTO {FF0000}( /LABIRINTO )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Bem vindo ao Labirinto!");
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Para sair do Labirinto: /sairlb");
SetPVarInt(playerid,"InMaze",1);
SetPlayerPos(playerid,348.2992,-2821.4980,50.9004);
SetPlayerFacingAngle(playerid,1.9277);
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/RM3", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para RAMPA MORTAL {CC3361}( /RM3 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),2576.2559,2336.5354,420.5029);
SetVehicleZAngle(GetPlayerVehicleID(playerid), 153.4051);}else{
SetPlayerPos(playerid,2576.2559,2336.5354,420.5029);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,153.4051);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/DROP", true) == 0) {
if(CallRemoteFunction("GetSubsystemStatus","") == 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[4]);
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o DROP{CC3361} ( /DROP )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
if(IsPlayerInAnyVehicle(playerid)){SendClientMessage(playerid, COLOUR_INFORMACAO, StringTable[5]);}
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-4252.5806,473.5434,864.7677);
SetVehicleZAngle(GetPlayerVehicleID(playerid), 267.9357);}else{
SetPlayerPos(playerid,-4252.5806,473.5434,864.7677);SetCameraBehindPlayer(playerid);Carregar(playerid);
SetPlayerFacingAngle(playerid,267.9357);}
Streamer_Update(playerid);
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/DROP2", true) == 0) {
if(CallRemoteFunction("GetSubsystemStatus","") == 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[4]);
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o DROP 2{CC3361} ( /DROP2 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
if(IsPlayerInAnyVehicle(playerid)){SendClientMessage(playerid, COLOUR_INFORMACAO, StringTable[5]);}
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),4721.6499,-1769.5573,621.0718);
SetVehicleZAngle(GetPlayerVehicleID(playerid), 84.2412);}else{
SetPlayerPos(playerid,4721.6499,-1769.5573,621.0718);SetCameraBehindPlayer(playerid);Carregar(playerid);
SetPlayerFacingAngle(playerid,84.2412);}
Streamer_Update(playerid);
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/DROP3", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o Novo DROP 3{CC3361} ( /DROP3 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),2564.6699,-690.7934,794.6172);
SetVehicleZAngle(GetPlayerVehicleID(playerid),186.6221);}else{
SetPlayerPos(playerid, 2564.6699,-690.7934,794.6172);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,186.6221);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/DROP4", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o DROP 4{CC3361} ( /DROP4 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),17.4230,2148.5332,703.6821);
SetVehicleZAngle(GetPlayerVehicleID(playerid),178.7654);}else{
SetPlayerPos(playerid, 17.4230,2148.5332,703.6821);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,178.7654);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/DROP5", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o DROP 5{CC3361} ( /DROP5 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-3650.6885,364.3030,1199.0989);
SetVehicleZAngle(GetPlayerVehicleID(playerid),253.0495);}else{
SetPlayerPos(playerid, -3650.6885,364.3030,1199.0989);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,253.0495);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/DROP6", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o DROP 6{CC3361} ( /DROP6 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),3586.7708,-2495.6621,885.7764);
SetVehicleZAngle(GetPlayerVehicleID(playerid),88.2345);}else{
SetPlayerPos(playerid, 3586.7708,-2495.6621,885.7764);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,88.2345);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);
return 1;}


if(strcmp(cmdtext, "/RM", true) == 0 || strcmp(cmdtext, "/rampamortal", true) == 0 || strcmp(cmdtext, "/superrampa", true) == 0 || strcmp(cmdtext, "/RM", true) == 0 || strcmp(cmdtext, "/rm", true) == 0 ) {
if(CallRemoteFunction("GetSubsystemStatus","") == 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[4]);
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para a RAMPA MORTAL {CC3361}( /RM )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
if(IsPlayerInAnyVehicle(playerid)){SendClientMessage(playerid, COLOUR_INFORMACAO, StringTable[5]);}
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),453.3016,812.5885,2147.2300+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid), 270.1718);}else{
SetPlayerPos(playerid,411.0976,821.9433,2147.0581);SetCameraBehindPlayer(playerid);Carregar(playerid);
SetPlayerFacingAngle(playerid,272.6784);}
Streamer_Update(playerid);
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/RM5", true) == 0) {
if(CallRemoteFunction("GetSubsystemStatus","") == 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[4]);
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para a RAMPA MORTAL 5 {CC3361}( /RM5 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
if(IsPlayerInAnyVehicle(playerid)){SendClientMessage(playerid, COLOUR_INFORMACAO, StringTable[5]);}
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),943.9925,-676.6890,631.0435);
SetVehicleZAngle(GetPlayerVehicleID(playerid), 359.4330);}else{
SetPlayerPos(playerid,943.9925,-676.6890,631.0435);SetCameraBehindPlayer(playerid);Carregar(playerid);
SetPlayerFacingAngle(playerid,359.4330);}
Streamer_Update(playerid);
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/subagua", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o SUBAGUA {CC3361}( /SUBAGUA )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-2888.677978, 1423.499023, -36.533981+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid), 266.6323);}else{
SetPlayerPos(playerid,-2888.677978, 1423.499023, -36.533981);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,266.6323);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/aerosf", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o AEROPORTO DE SAN FIERRO {CC3361}( /AEROSF )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-1556.7877,-441.9134,6.0000+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid), 316.0595);}else{
SetPlayerPos(playerid,-1556.7877,-441.9134,6.0000);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,316.0595);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/grove", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para a GROVE STREET {CC3361}( /GROVE )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),2500.9519,-1668.9618,13.3554+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),81.020889);}else{
SetPlayerPos(playerid,2500.9519,-1668.9618,13.3554);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,81.020889);
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
}return 1;}

if(strcmp(cmdtext, "/topo", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o TOPO LV {CC3361}( /TOPO )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
if(IsPlayerInAnyVehicle(playerid)){SendClientMessage(playerid, COLOUR_INFORMACAO, StringTable[5]);}
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),1944.4521,1631.5057,239.5061+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),272.2324);}else{
SetPlayerPos(playerid,1944.4521,1631.5057,239.5061);SetCameraBehindPlayer(playerid);Carregar(playerid);
SetPlayerFacingAngle(playerid,272.2324);
GivePlayerWeapon(playerid, 46, 1);}
Streamer_Update(playerid);
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/drift", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o DRIFT {CC3361}( /DRIFT )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-303.3920,1521.1327,75.3594);
SetVehicleZAngle(GetPlayerVehicleID(playerid),184.6425);}else{
SetPlayerPos(playerid,-303.3920,1521.1327,75.3594);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,184.6425);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/drift2", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o DRIFT 2 {CC3361}( /DRIFT2 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),70.3422, -3208.2131, 91.6682);
SetVehicleZAngle(GetPlayerVehicleID(playerid),312.3222);}else{
SetPlayerPos(playerid,70.3422, -3208.2131, 91.6682);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,184.6425);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/pilar", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o PILAR DA PONTE SF {CC3361}( /PILAR )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-2682.2175,1930.9640,3.2226+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),280.1155);}else{
SetPlayerPos(playerid,-2682.2175,1930.9640,3.2226);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,280.1155);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/deserto", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o DESERTO {CC3361}( /DESERTO )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-700.7104,2342.8298,127.4474+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),146.8660);}else{
SetPlayerPos(playerid,-700.7104,2342.8298,127.4474);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,146.8660);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/ls", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para LOS SANTOS {CC3361}( /LS )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),1130.1051,-1450.3822,15.7969+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),2.7676);}else{
SetPlayerPos(playerid,1130.1051,-1450.3822,15.7969);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,2.7676);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/praia", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para a PRAIA DE LOS SANTOS {CC3361}( /PRAIA )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),227.9339,-1815.5609,4.2493+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),180.1587);}else{
SetPlayerPos(playerid,227.9339,-1815.5609,4.2493);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,146.8660);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/rally", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para a PISTA DE RALLY {CC3361}( /RALLY )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-303.9771,-2250.1445,29.4735+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),107.3374);}else{
SetPlayerPos(playerid,-303.9771,-2250.1445,29.4735);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,107.3374);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/chilliad", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o MONTE CHILLIAD {CC3361}( /CHILLIAD )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-2321.0469,-1625.6339,483.7063+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),213.7691);}else{
SetPlayerPos(playerid,-2321.0469,-1625.6339,483.7063);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,213.7691);
SetCameraBehindPlayer(playerid);
GivePlayerWeapon(playerid, 46, 1);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/sf", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para SAN FIERRO {CC3361}( /SF )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-1994.1210,108.9522,27.5391+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),87.9631);}else{
SetPlayerPos(playerid,-1994.1210,108.9522,27.5391);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,87.9631);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/exsf", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o EXTREMO DE SAN FIERRO {CC3361}( /EXSF )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-2836.4126,2732.3691,239.3176+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),194.9958);}else{
SetPlayerPos(playerid,-2836.4126,2732.3691,239.3176);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,194.9958);
GivePlayerWeapon(playerid, 46, 1);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/rh", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para a REPRESA HOOVER DAM {CC3361}( /RH )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-950.8074,1921.5872,132.4391+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),263.2925);}else{
SetPlayerPos(playerid,-950.8074,1921.5872,132.4391);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,263.2925);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/area51", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para a AREA 51 {CC3361}( /AREA51 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),215.3240,1907.3092,17.6406+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),175.3665);}else{
SetPlayerPos(playerid,215.3240,1907.3092,17.6406);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,175.3665);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/aerolv", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o AEROPORTO DE LAS VENTURAS {CC3361}( /AEROLV )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),1634.3506,1560.3524,10.8112+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),85.0883);}else{
SetPlayerPos(playerid,1634.3506,1560.3524,10.8112);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,85.0883);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/fz", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para a FAZENDA {CC3361}( /FZ )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-1150.5137,-1115.0033,128.2725+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),92.8502);}else{
SetPlayerPos(playerid,-1150.5137,-1115.0033,128.2725);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,92.8502);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/re", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para a REFINARIA {CC3361}( /RE )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),277.6962,1349.1051,10.1260+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),4.1360);}else{
SetPlayerPos(playerid,277.6962,1349.1051,10.1260);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,4.1360);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/jump", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o JUMP {CC3361}( /JUMP )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-1810.5317,575.7595,234.8906+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),4.2578);}else{
SetPlayerPos(playerid,-1810.5317,575.7595,234.8906);
SetPlayerFacingAngle(playerid,4.2578);SetCameraBehindPlayer(playerid);
GivePlayerWeapon(playerid, 46, 1);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/tv", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para a TORRE DE TV {CC3361}( /TV )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-2525.3604,-613.6185,132.5625+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),270.9312);}else{
SetPlayerPos(playerid,-2525.3604,-613.6185,132.5625);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,270.9312);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/bar", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o BAR {CC3361}( /BAR )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-1533.9814,-2766.8796,48.5335+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),53.3483);}else{
SetPlayerPos(playerid,-1533.9814,-2766.8796,48.5335);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,53.3483);
SetCameraBehindPlayer(playerid);
Streamer_Update(playerid);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/aeroab", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o AEROPORTO ABANDONADO {CC3361}( /AEROAB )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);
new rand = random(sizeof(AeroABPos));
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),AeroABPos[rand][0], AeroABPos[rand][1], AeroABPos[rand][2]+5);
SetVehicleZAngle(GetPlayerVehicleID(playerid),AeroABPos[rand][3]);
}else{
SetPlayerPos(playerid,AeroABPos[rand][0], AeroABPos[rand][1], AeroABPos[rand][2]);
SetPlayerFacingAngle(playerid,AeroABPos[rand][3]);
SetCameraBehindPlayer(playerid);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/aerols", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o AEROPORTO DE LOS SANTOS {CC3361}( /AEROLS )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),1918.0791,-2248.0149,13.1541+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),183.5187);}else{
SetPlayerPos(playerid,1918.0791,-2248.0149,13.1541);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,183.5187);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/rancho", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o RANCHO {CC3361}( /RANCHO )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-706.5253,954.1293,12.4395+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),263.1609);}else{
SetPlayerPos(playerid,-706.5253,954.1293,12.4395);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,263.1609);
Streamer_Update(playerid);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/bl", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para a BALADA {CC3361}( /BL )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),1828.0475,-1681.9315,13.5469);
SetVehicleZAngle(GetPlayerVehicleID(playerid),275.1979);}else{
SetPlayerPos(playerid,1828.0475,-1681.9315,13.5469);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,275.1979);
Streamer_Update(playerid);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/MDLS", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para MADD DOGGS{CC3361} ( /MDLS )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),1242.0110,-747.0634,94.7665);
SetVehicleZAngle(GetPlayerVehicleID(playerid),190.0243);}else{
SetPlayerPos(playerid,1242.0110,-747.0634,94.7665);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,190.0243);
Streamer_Update(playerid);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/tb", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o Tobogã {CC3361}( /TB )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),1568.6034,-1293.6143,335.3800);
SetVehicleZAngle(GetPlayerVehicleID(playerid),263.1609);}else{
SetPlayerPos(playerid,1568.6034,-1293.6143,335.3800);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,263.1609);
Streamer_Update(playerid);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/morro", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o MORRO {CC3361}( /MORRO )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-1428.5514,-951.5047,201.0938+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),273.8198);}else{
SetPlayerPos(playerid,-1428.5514,-951.5047,201.0938);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,273.8198);
Streamer_Update(playerid);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}


if(strcmp(cmdtext, "/lcy", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para LIBERTY CITY {CC3361}( /LCY )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,1);
SetPlayerPos(playerid,-726.0500,518.7230,1371.9766);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,176.8553);
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/ammu", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o AMMU-NATION DE LAS VENTURAS {CC3361}( /AMMU )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),2152.9194,943.3663,10.8203);
SetVehicleZAngle(GetPlayerVehicleID(playerid),263.1609);}else{
SetPlayerPos(playerid,2152.9194,943.3663,10.8203);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,263.1609);
Streamer_Update(playerid);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);return 1;}


if(strcmp(cmdtext, "/ammuls", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o AMMU-NATION DE LOS SANTOS {CC3361}( /AMMULS )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),1359.7175,-1280.2335,13.3708);
SetVehicleZAngle(GetPlayerVehicleID(playerid),263.1609);}else{
SetPlayerPos(playerid,1359.7175,-1280.2335,13.3708);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,263.1609);
Streamer_Update(playerid);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);return 1;}

if(strcmp(cmdtext, "/ammueb", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o AMMU-NATION DE EL QUEBRADOS {CC3361}( /AMMUEB )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-1510.6292,2603.3015,55.6917);
SetVehicleZAngle(GetPlayerVehicleID(playerid),183.5187);}else{
SetPlayerPos(playerid,-1510.6292,2603.3015,55.6917);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,183.5187);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}


if(strcmp(cmdtext, "/ammufc", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o AMMU-NATION DE FORT CARSON {CC3361}( /AMMUFC )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-307.1789,830.7644,13.1354);
SetVehicleZAngle(GetPlayerVehicleID(playerid),183.5187);}else{
SetPlayerPos(playerid,-307.1789,830.7644,13.1354);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,183.5187);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/ammusf", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o AMMU-NATION DE SAN FIERRO {CC3361}( /AMMUSF )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,0);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),-2625.5571,214.6098,4.4801);
SetVehicleZAngle(GetPlayerVehicleID(playerid),183.5187);}else{
SetPlayerPos(playerid,-2625.5571,214.6098,4.4801);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,183.5187);
SetCameraBehindPlayer(playerid);
}ProgramarAntiFlood(playerid);return 1;}

if(strcmp(cmdtext, "/evento", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você já está no evento. Para sair: /SAIR");
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
if(EventoAtivo != 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Sem eventos no momento");
if(EventoPausado == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O evento não está liberado");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
if(EventoDarSpeed == 1){
StuntSuperSpeed[playerid] = true;
if(StuntSuperSpeed[playerid] == true){
SendClientMessage(playerid,COLOUR_AVISO,"[AVISO]: Speed liberado nesse evento!");
}}
if(EventoDarSpeed == 0){
StuntSuperSpeed[playerid] = false;
}
NoEvento[playerid] = 1;
RemoverTodosAttachsObj(playerid);
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para o {FF0000}EVENTO {FFFFFF}%s {FFFF0D}( /EVENTO )", pname,EventoNome);SendClientMessageToAll(COLOUR_EVENTO, string);
//EventoNome
if(EventoDesarmar == 1){ResetPlayerWeapons(playerid);SetPlayerFightingStyle(playerid, FIGHT_STYLE_NORMAL);}
if(EventoGranadas == 0){SetPlayerAmmo(playerid,16,0);}
if(EventoProibirGC == 1){GodCarOn[playerid] = 0;}
if(EventoDarArmaID != 0){GivePlayerWeapon(playerid,EventoDarArmaID,9999);}
if(EventoDarLife == 1) {if(EventoDarColete == 0)SetPlayerArmour(playerid,0.0);SetPlayerHealth(playerid,100.0);}
if(EventoDarColete == 1) {SetPlayerArmour(playerid,100.0);}
if(EventoKitRun){
ResetPlayerWeapons(playerid);
GivePlayerWeapon(playerid, 22, 300);
GivePlayerWeapon(playerid, 28, 300);
GivePlayerWeapon(playerid, 26, 300);}
if(EventoKitWalk){
ResetPlayerWeapons(playerid);
GivePlayerWeapon(playerid, 24, 300);
GivePlayerWeapon(playerid, 25, 300);
GivePlayerWeapon(playerid, 31, 300);
GivePlayerWeapon(playerid, 34, 300);
GivePlayerWeapon(playerid, 29, 300);}
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && EventoVeiculos == 1 && evento_vw == 0 && evento_in == 0){
SetVehiclePos(GetPlayerVehicleID(playerid),evento_x,evento_y,evento_z+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid),evento_f);}else{
SetPlayerInterior(playerid, evento_in);
SetPlayerVirtualWorld(playerid, evento_vw);
if(EventoSPA == false) SetPlayerPos(playerid,evento_x,evento_y,evento_z); else SetPlayerPosRandom(playerid,evento_x,evento_y,evento_z);
SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,evento_f);
if(EventoCarregar == 1) {Carregar(playerid);}}
if(EventoDarVeiculoID != 0) SetTimerEx("CriarVeiculodeEventoParaPlayer",2000,0, "ii", playerid,EventoDarVeiculoID);
if(EventoCorridaCC == true){
CarregarCacar(playerid);
Streamer_Update(playerid);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}



if(strcmp(cmd, "/duelo", true) == 0 || strcmp(cmd, "/arena", true) == 0 || strcmp(cmd, "/dm", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid, 1);
Arena[playerid] = 1;
ArenaTipo[playerid] = 1;
new rand = random(sizeof(RunPos));
SetPlayerPos(playerid, RunPos[rand][0], RunPos[rand][1], RunPos[rand][2]);
SetPlayerFacingAngle(playerid,RunPos[rand][3]);
SetPlayerInterior(playerid, 15);
SetCameraBehindPlayer(playerid);
ResetPlayerWeapons(playerid);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,100);
GivePlayerWeapon(playerid, 22, 9999);
GivePlayerWeapon(playerid, 28, 9999);
GivePlayerWeapon(playerid, 26, 9999);
GameTextForPlayer(playerid,"~r~ARENA!", 3000, 5);
CarregarCacar(playerid);
Streamer_Update(playerid);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para a ARENA DM. Quem vai?{FF0000} ( /ARENA )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_DICA, "");
SendClientMessage(playerid, COLOUR_DICA, "VOCÊ ESTÁ EM UMA ARENA DM, O OBJETIVO É MATAR TODOS QUE");
SendClientMessage(playerid, COLOUR_DICA, "VIREM AQUI, LEMBRANDO QUE, AO MATAR, SEU COLETE E SAUDE");
SendClientMessage(playerid, COLOUR_DICA, "SERÃO RECUPERADOS AUTOMATICAMENTE, ENTÃO MATE!");
SendClientMessage(playerid, COLOUR_DICA, "");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/ranking", true) == 0 || strcmp(cmd, "/rank", true) == 0 || strcmp(cmd, "/top10", true) == 0 || strcmp(cmd, "/ranks", true) == 0) {
MostrarMenuRanks(playerid);
return 1;}

if(strcmp(cmd, "/reis", true) == 0 || strcmp(cmd, "/melhores", true) == 0) {
ShowReisForPlayer(playerid,5500);
return 1;}

if(strcmp(cmd, "/neon", true) == 0 || strcmp(cmd, "/neons", true) == 0) {
if(Neons < 20)
SendPlayerFormattedText(playerid, COLOUR_INFORMACAO, "[INFO]: Escolha seu neon na lista. {C0C0C0}[Veículos com neon: %i de 10]", Neons/2);
else
SendClientMessage(playerid, COLOUR_AVISO, "[AVISO]: Todas as 10 vagas para neon estão ocupadas no momento");
ShowNeonsForPlayer(playerid);
return 1;}

if(strcmp(cmd, "/neonfix", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
Neons = 0;
for(new i; i < GetMaxPlayers(); i++)
{
	if(IsPlayerConnected(i))
	{
	if(Neon[0][i] != -1) Neons++;
	if(Neon[1][i] != -1) Neons++;
	}
}
format(string, sizeof(string), "[INFO]: Sistema de neons restaurado! {FFFFFF}[%i veículos com neon | %i objetos]", Neons/2,Neons);
SendClientMessage(playerid, COLOUR_INFORMACAO, string);
return 1;}

if(strcmp(cmdtext, "/policia", true) == 0 ) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
SetPlayerInterior(playerid,10);
SetPlayerVirtualWorld(playerid, 521);
Arena[playerid] = 1;
ArenaTipo[playerid] = 1;
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi Combater Como {FF0000}POLICIAL {FFFFFF} ( /POLICIA )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,10);
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
GameTextForPlayer(playerid,"~b~VOCE ENTROU COMO POLICIAL", 3000, 5);
SetPlayerSkin(playerid, 285 );
SetPlayerPos(playerid,-974.1444,1061.1946,1345.6743);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,-277.7560);}
else{
GameTextForPlayer(playerid,"~b~VOCE ENTROU COMO POLICIAL", 3000, 5);
SetPlayerSkin(playerid, 285 );
SetPlayerPos(playerid,-974.1444,1061.1946,1345.6743);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,-277.7560);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmdtext, "/ladrao", true) == 0 ) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
SetPlayerInterior(playerid,10);
SetPlayerVirtualWorld(playerid, 521);
Arena[playerid] = 1;
ArenaTipo[playerid] = 1;
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi Combater Como {FF0000}LADRAO {FFFFFF} ( /LADRAO )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,10);
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
GameTextForPlayer(playerid,"~b~VOCE ENTROU COMO LADRAO", 3000, 5);
SetPlayerSkin(playerid, 28 );
SetPlayerPos(playerid,-1131.7355,1057.5320,1346.4130);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,277.7560);}
else{
GameTextForPlayer(playerid,"~b~VOCE ENTROU COMO LADRAO", 3000, 5);
SetPlayerSkin(playerid, 28 );
SetPlayerPos(playerid,-1131.7355,1057.5320,1346.4130);SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,277.7560);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}


if(strcmp(cmd, "/sss", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid, 21);
Arena[playerid] = 1;
ArenaTipo[playerid] = 12;
StuntSuperSpeed[playerid] = true;
SetPlayerPos(playerid, -1700.3066,-216.7819,14.1484); // Warp the player
SetPlayerFacingAngle(playerid,314.8095);
SetCameraBehindPlayer(playerid);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,100);
ResetPlayerWeapons(playerid);
GameTextForPlayer(playerid,"~r~Stunt Super Speed!", 3000, 5);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para a arena de Stunt Super Speed {CC3361}( /SSS )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO:] Para usar os poderes, use o clique direito do mouse e a tecla CTRL! (Em um veículo)");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/md", true) == 0 || strcmp(cmd, "/guerra", true) == 0 || strcmp(cmd, "/mdg", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
ShowPlayerDialog(playerid,993,DIALOG_STYLE_LIST,"Escolha a base em que deseja nascer:","Base dos Hunters\nBase dos Hydras\nBase dos Rhinos\nBase dos Seasparrows","Selecionar","Voltar");
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/AD", true) == 0 || strcmp(cmd, "/AAD", true) == 0 || strcmp(cmd, "/AAD", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(AAD_Vai[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você já se cadastrou! Agora aguarde!");
if(AAD_Lobby == 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O combate A/D está indisponível no momento");
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
AAD_Vai[playerid] = 1;
format(string, sizeof(string), "{FF387A}%s {FFFFFF}vai combater no A/D [%s] {CC3361}( /AD )", pname,AAD_Tipo_STR);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você será teleportado automaticamente para o A/D, aguarde...");
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/PVC", true) == 0 || strcmp(cmd, "/PLAYERVSCARROS", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(PVC_Vai[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você já se cadastrou! Agora aguarde!");
if(PVC_Lobby == 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O combate PVC está indisponível no momento");
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
PVC_Vai[playerid] = 1;
format(string, sizeof(string), "{FF387A}%s {FFFFFF}vai combater no PVC: [%s] {CC3361}( /PVC )", pname, PVC_Tipo_STR);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você será teleportado automaticamente para o PVC, aguarde...");
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/PL", true) == 0 || strcmp(cmd, "/PLAYERVSCARROS", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(PL_Vai[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você já se cadastrou! Agora aguarde!");
if(PL_Lobby == 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O combate PL está indisponível no momento");
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
PL_Vai[playerid] = 1;
format(string, sizeof(string), "[PL]: {FF387A}%s {FFFFFF}vai jogar POLICIA X LADRAO: {CC3361}( /PL )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você será teleportado automaticamente para o PL, aguarde...");
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/doze", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid, 2);
Arena[playerid] = 1;
ArenaTipo[playerid] = 1;
new rand = random(sizeof(RunPos));
SetPlayerPos(playerid, RunPos[rand][0], RunPos[rand][1], RunPos[rand][2]);
SetPlayerFacingAngle(playerid,RunPos[rand][3]);
SetPlayerInterior(playerid, 15);
SetCameraBehindPlayer(playerid);
ResetPlayerWeapons(playerid);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,100);
GivePlayerWeapon(playerid, 26, 9999);
GameTextForPlayer(playerid,"~r~Sawn Off!", 3000, 5);
CarregarCacar(playerid);
Streamer_Update(playerid);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para a arena de SAWN-OFF. Quem vai? {FF0000}( /DOZE )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_DICA, "");
SendClientMessage(playerid, COLOUR_DICA, "VOCÊ ESTÁ EM UMA ARENA DM, O OBJETIVO É MATAR TODOS QUE");
SendClientMessage(playerid, COLOUR_DICA, "VIREM AQUI, LEMBRANDO QUE, AO MATAR, SEU COLETE E SAUDE");
SendClientMessage(playerid, COLOUR_DICA, "SERÃO RECUPERADOS AUTOMATICAMENTE, ENTÃO MATE!");
SendClientMessage(playerid, COLOUR_DICA, "");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/m4", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid, 3);
Arena[playerid] = 1;
ArenaTipo[playerid] = 1;
new rand = random(sizeof(RunPos));
SetPlayerPos(playerid, RunPos[rand][0], RunPos[rand][1], RunPos[rand][2]);
SetPlayerFacingAngle(playerid,RunPos[rand][3]);
SetPlayerInterior(playerid, 15);
SetCameraBehindPlayer(playerid);
ResetPlayerWeapons(playerid);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,100);
GivePlayerWeapon(playerid, 31, 9999);
GameTextForPlayer(playerid,"~r~Colt M4!", 3000, 5);
CarregarCacar(playerid);
Streamer_Update(playerid);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para a arena de COLT M4. Quem vai? {FF0000}( /M4 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_DICA, "");
SendClientMessage(playerid, COLOUR_DICA, "VOCÊ ESTÁ EM UMA ARENA DM, O OBJETIVO É MATAR TODOS QUE");
SendClientMessage(playerid, COLOUR_DICA, "VIREM AQUI, LEMBRANDO QUE, AO MATAR, SEU COLETE E SAUDE");
SendClientMessage(playerid, COLOUR_DICA, "SERÃO RECUPERADOS AUTOMATICAMENTE, ENTÃO MATE!");
SendClientMessage(playerid, COLOUR_DICA, "");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/tec9", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid, 4);
Arena[playerid] = 1;
ArenaTipo[playerid] = 1;
new rand = random(sizeof(RunPos));
SetPlayerPos(playerid, RunPos[rand][0], RunPos[rand][1], RunPos[rand][2]);
SetPlayerFacingAngle(playerid,RunPos[rand][3]);
SetPlayerInterior(playerid, 15);
SetCameraBehindPlayer(playerid);
ResetPlayerWeapons(playerid);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,100);
GivePlayerWeapon(playerid, 32, 9999);
GameTextForPlayer(playerid,"~r~TEC9!", 3000, 5);
CarregarCacar(playerid);
Streamer_Update(playerid);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para a arena de TEC9. Quem vai? {FF0000}( /TEC9 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_DICA, "");
SendClientMessage(playerid, COLOUR_DICA, "VOCÊ ESTÁ EM UMA ARENA DM, O OBJETIVO É MATAR TODOS QUE");
SendClientMessage(playerid, COLOUR_DICA, "VIREM AQUI, LEMBRANDO QUE, AO MATAR, SEU COLETE E SAUDE");
SendClientMessage(playerid, COLOUR_DICA, "SERÃO RECUPERADOS AUTOMATICAMENTE, ENTÃO MATE!");
SendClientMessage(playerid, COLOUR_DICA, "");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/serra", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid, 5);
Arena[playerid] = 1;
ArenaTipo[playerid] = 1;
new rand = random(sizeof(RunPos));
SetPlayerPos(playerid, RunPos[rand][0], RunPos[rand][1], RunPos[rand][2]);
SetPlayerFacingAngle(playerid,RunPos[rand][3]);
SetPlayerInterior(playerid, 15);
SetCameraBehindPlayer(playerid);
ResetPlayerWeapons(playerid);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,100);
GivePlayerWeapon(playerid, 9, 9999);
GameTextForPlayer(playerid,"~r~MOTOSSERRA!", 3000, 5);
CarregarCacar(playerid);
Streamer_Update(playerid);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para a arena de MOTOSSERRA. Quem vai? {FF0000}( /SERRA )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_DICA, "");
SendClientMessage(playerid, COLOUR_DICA, "VOCÊ ESTÁ EM UMA ARENA DM, O OBJETIVO É MATAR TODOS QUE");
SendClientMessage(playerid, COLOUR_DICA, "VIREM AQUI, LEMBRANDO QUE, AO MATAR, SEU COLETE E SAUDE");
SendClientMessage(playerid, COLOUR_DICA, "SERÃO RECUPERADOS AUTOMATICAMENTE, ENTÃO MATE!");
SendClientMessage(playerid, COLOUR_DICA, "");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/granada", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid, 6);
Arena[playerid] = 1;
ArenaTipo[playerid] = 1;
new rand = random(sizeof(RunPos));
SetPlayerPos(playerid, RunPos[rand][0], RunPos[rand][1], RunPos[rand][2]);
SetPlayerFacingAngle(playerid,RunPos[rand][3]);
SetPlayerInterior(playerid, 15);
SetCameraBehindPlayer(playerid);
ResetPlayerWeapons(playerid);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,100);
GivePlayerWeapon(playerid, 16, 9999);
GameTextForPlayer(playerid,"~r~GRANADA!", 3000, 5);
CarregarCacar(playerid);
Streamer_Update(playerid);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para a arena de GRANADAS. Quem vai? {FF0000}( /GRANADA )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_DICA, "");
SendClientMessage(playerid, COLOUR_DICA, "VOCÊ ESTÁ EM UMA ARENA DM, O OBJETIVO É MATAR TODOS QUE");
SendClientMessage(playerid, COLOUR_DICA, "VIREM AQUI, LEMBRANDO QUE, AO MATAR, SEU COLETE E SAUDE");
SendClientMessage(playerid, COLOUR_DICA, "SERÃO RECUPERADOS AUTOMATICAMENTE, ENTÃO MATE!");
SendClientMessage(playerid, COLOUR_DICA, "");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/pistola", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid, 7);
Arena[playerid] = 1;
ArenaTipo[playerid] = 1;
new rand = random(sizeof(WalkPos));
SetPlayerPos(playerid, WalkPos[rand][0], WalkPos[rand][1], WalkPos[rand][2]);
SetPlayerFacingAngle(playerid,WalkPos[rand][3]);
SetPlayerInterior(playerid, 1);
SetCameraBehindPlayer(playerid);
ResetPlayerWeapons(playerid);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,100);
GivePlayerWeapon(playerid, 24, 9999);
GameTextForPlayer(playerid,"~r~DESERT EAGLE!", 3000, 5);
CarregarCacar(playerid);
Streamer_Update(playerid);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para a arena de DESERT EAGLE. Quem vai? {FF0000}( /PISTOLA )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_DICA, "");
SendClientMessage(playerid, COLOUR_DICA, "VOCÊ ESTÁ EM UMA ARENA DM, O OBJETIVO É MATAR TODOS QUE");
SendClientMessage(playerid, COLOUR_DICA, "VIREM AQUI, LEMBRANDO QUE, AO MATAR, SEU COLETE E SAUDE");
SendClientMessage(playerid, COLOUR_DICA, "SERÃO RECUPERADOS AUTOMATICAMENTE, ENTÃO MATE!");
SendClientMessage(playerid, COLOUR_DICA, "");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/porrada", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid, 8);
Arena[playerid] = 1;
ArenaTipo[playerid] = 2;
new rand = random(sizeof(RunPos));
SetPlayerPos(playerid, RunPos[rand][0], RunPos[rand][1], RunPos[rand][2]);
SetPlayerFacingAngle(playerid,RunPos[rand][3]);
SetPlayerInterior(playerid, 15);
SetCameraBehindPlayer(playerid);
ResetPlayerWeapons(playerid);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,0);
GivePlayerWeapon(playerid, 1, 9999);
GameTextForPlayer(playerid,"~r~PORRADA!", 3000, 5);
CarregarCacar(playerid);
Streamer_Update(playerid);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para a arena de PORRADA. Quem vai? {FF0000}( /PORRADA )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_DICA, "");
SendClientMessage(playerid, COLOUR_DICA, "VOCÊ ESTÁ EM UMA ARENA DM, O OBJETIVO É MATAR TODOS QUE");
SendClientMessage(playerid, COLOUR_DICA, "VIREM AQUI, LEMBRANDO QUE, AO MATAR, SUA SAUDE");
SendClientMessage(playerid, COLOUR_DICA, "SERA RECUPERADA AUTOMATICAMENTE, ENTÃO MATE!");
SendClientMessage(playerid, COLOUR_DICA, "");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/pinga", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
SetPlayerInterior(playerid,1);
SetPlayerVirtualWorld(playerid, 9);
Arena[playerid] = 1;
ArenaTipo[playerid] = 2;
new rand = random(sizeof(RunPos));
SetPlayerPos(playerid, RunPos[rand][0], RunPos[rand][1], RunPos[rand][2]);
SetPlayerFacingAngle(playerid,RunPos[rand][3]);
ResetPlayerWeapons(playerid);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,100);
GivePlayerWeapon(playerid, 22, 9999);
GivePlayerWeapon(playerid, 28, 9999);
GivePlayerWeapon(playerid, 26, 9999);
GameTextForPlayer(playerid,"~r~PINGA MATA!", 3000, 5);
CarregarCacar(playerid);
Streamer_Update(playerid);
SetPlayerDrunkLevel (playerid, 5000);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para a arena de BÊBADOS. Quem vai?{FF0000}( /PINGA )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_DICA, "");
SendClientMessage(playerid, COLOUR_DICA, "VOCÊ ESTÁ EM UMA ARENA DM, O OBJETIVO É MATAR TODOS QUE");
SendClientMessage(playerid, COLOUR_DICA, "VIREM AQUI, LEMBRANDO QUE, AO MATAR, SEU COLETE E SAUDE");
SendClientMessage(playerid, COLOUR_DICA, "SERÃO RECUPERADOS AUTOMATICAMENTE, ENTÃO MATE!");
SendClientMessage(playerid, COLOUR_DICA, "");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/x1", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(X1CLOSED == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O X1 esta fechado para remoção de sangue e cadáveres");
if(X1 > 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Um duelo já está em progresso no X1! Tente mais tarde!");
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
ResetAwayStatus(playerid);
AwaySeconds[playerid] = 0;
//if(GetPVarInt(playerid,"PVarFPS") < 20 && GetPVarInt(playerid,"PVarFPS") != 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Seu computador é lento demais para tirar x1. (Limite: 20 FPS)");
X1 = X1+1;
//printf("[X1] Teleporte para X1: %i", X1);
ArenaTipo[playerid] = 3;
Arena[playerid] = 1;
SetPlayerInterior(playerid,0);
RemoverTodosAttachsObj(playerid);
SetPlayerVirtualWorld(playerid, 10);
new rand = random(sizeof(RunPos));
SetPlayerPos(playerid, RunPos[rand][0], RunPos[rand][1], RunPos[rand][2]);
SetPlayerFacingAngle(playerid,RunPos[rand][3]);
SetPlayerInterior(playerid, 1);
SetCameraBehindPlayer(playerid);
ResetPlayerWeapons(playerid);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,100);
GivePlayerWeapon(playerid, 22, 9999);
GivePlayerWeapon(playerid, 28, 9999);
GivePlayerWeapon(playerid, 26, 9999);
GameTextForPlayer(playerid,"~r~X1!~n~~w~ MANDA VER!", 3000, 5);
CarregarCacar(playerid);
Streamer_Update(playerid);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para o x1 {FF0000}( /X1 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_INFORMACAO, "");
SendClientMessage(playerid, COLOUR_AVISO, "[AVISO]: Se ficar sem se movimentar por mais de um minuto no X1 será automaticamente kickado");
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Para sair do X1 digite /SAIR - Se ganhar o duelo, ganhará respawn automático");
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Bem-Vindo ao X1! {FFFFFF}Uma arena especial para duelos entre 2 players com armas RUN!");
SendClientMessage(playerid, COLOUR_INFORMACAO, "");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/wk", true) == 0 || strcmp(cmd, "/walk", true) == 0 || strcmp(cmd, "/duelo2", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid, 12);
Arena[playerid] = 1;
ArenaTipo[playerid] = 1;
new rand = random(sizeof(WalkPos));
SetPlayerPos(playerid, WalkPos[rand][0], WalkPos[rand][1], WalkPos[rand][2]);
SetPlayerFacingAngle(playerid,WalkPos[rand][3]);
SetPlayerInterior(playerid, 1);
SetCameraBehindPlayer(playerid);
ResetPlayerWeapons(playerid);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,100);
GivePlayerWeapon(playerid, 4, 2);
GivePlayerWeapon(playerid, 24, 9999);
GivePlayerWeapon(playerid, 25, 9999);
GivePlayerWeapon(playerid, 31, 9999);
GivePlayerWeapon(playerid, 34, 9999);
GivePlayerWeapon(playerid, 29, 9999);
GameTextForPlayer(playerid,"~r~Arena Walk!", 3000, 5);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
CarregarCacar(playerid);
Streamer_Update(playerid);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para a arena WALK. Quem vai? {FF0000}( /WK )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_DICA, "");
SendClientMessage(playerid, COLOUR_DICA, "VOCÊ ESTÁ EM UMA ARENA DM, O OBJETIVO É MATAR TODOS QUE");
SendClientMessage(playerid, COLOUR_DICA, "VIREM AQUI, LEMBRANDO QUE, AO MATAR, SEU COLETE E SAUDE");
SendClientMessage(playerid, COLOUR_DICA, "SERÃO RECUPERADOS AUTOMATICAMENTE, ENTÃO MATE!");
SendClientMessage(playerid, COLOUR_DICA, "");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/extintor", true) == 0 || strcmp(cmd, "/ext", true) == 0 || strcmp(cmd, "/ex", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid, 13);
Arena[playerid] = 1;
ArenaTipo[playerid] = 1;
new rand = random(sizeof(RunPos));
SetPlayerPos(playerid, RunPos[rand][0], RunPos[rand][1], RunPos[rand][2]);
SetPlayerFacingAngle(playerid,RunPos[rand][3]);
SetPlayerInterior(playerid, 15);
SetCameraBehindPlayer(playerid);
ResetPlayerWeapons(playerid);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,100);
GivePlayerWeapon(playerid, 42, 50500);
GameTextForPlayer(playerid,"~r~ARENA DE EXTINTOR!", 3000, 5);
CarregarCacar(playerid);
Streamer_Update(playerid);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para a arena de EXTINTOR. Quem vai? {FF0000}( /EX )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_DICA, "");
SendClientMessage(playerid, COLOUR_DICA, "VOCÊ ESTÁ EM UMA ARENA DM, O OBJETIVO É MATAR TODOS QUE");
SendClientMessage(playerid, COLOUR_DICA, "VIREM AQUI, LEMBRANDO QUE, AO MATAR, SEU COLETE E SAUDE");
SendClientMessage(playerid, COLOUR_DICA, "SERÃO RECUPERADOS AUTOMATICAMENTE, ENTÃO MATE!");
SendClientMessage(playerid, COLOUR_DICA, "");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/mg", true) == 0 || strcmp(cmd, "/minigun", true) == 0 || strcmp(cmd, "/mg3", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
ResetPlayerWeapons(playerid);
Arena[playerid] = 1;
ArenaTipo[playerid] = 4;
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid, 14);
new rand = random(sizeof(CombatePos));
SetPlayerPos(playerid, CombatePos[rand][0], CombatePos[rand][1], CombatePos[rand][2]);
SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,CombatePos[rand][3]);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,100);
GivePlayerWeapon(playerid, 38, 99999);
GameTextForPlayer(playerid,"~r~COMBATE DE MINIGUN!", 3000, 5);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para o combate de MINIGUN. Quem vai? {FF0000}( /MG )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_DICA, "");
SendClientMessage(playerid, COLOUR_DICA, "VOCÊ ESTÁ EM UM COMBATE, A PARADA E O SEGUINTE METE BALA EM TODO MUNDO");
SendClientMessage(playerid, COLOUR_DICA, "LEMBRANDO QUE, AO MATAR, SEU COLETE E SAUDE");
SendClientMessage(playerid, COLOUR_DICA, "SERÃO RECUPERADOS AUTOMATICAMENTE, ENTÃO MATE PORRA!");
SendClientMessage(playerid, COLOUR_DICA, "");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/rocket", true) == 0 || strcmp(cmd, "/bz", true) == 0 || strcmp(cmd, "/bazuca", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
ResetPlayerWeapons(playerid);
Arena[playerid] = 1;
ArenaTipo[playerid] = 5;
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid, 15);
new rand = random(sizeof(CombatePos));
SetPlayerPos(playerid, CombatePos[rand][0], CombatePos[rand][1], CombatePos[rand][2]);
SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,CombatePos[rand][3]);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,100);
GivePlayerWeapon(playerid, 35, 99999);
GameTextForPlayer(playerid,"~r~COMBATE DE BAZUCA!", 3000, 5);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para o combate de BAZUCA. Quem vai? {FF0000}( /BZ )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_DICA, "");
SendClientMessage(playerid, COLOUR_DICA, "VOCÊ ESTÁ EM UM COMBATE, O OBJETIVO É MATAR TODOS QUE");
SendClientMessage(playerid, COLOUR_DICA, "VIREM AQUI, LEMBRANDO QUE, AO MATAR, SEU COLETE E SAUDE");
SendClientMessage(playerid, COLOUR_DICA, "SERÃO RECUPERADOS AUTOMATICAMENTE, ENTÃO MATE!");
SendClientMessage(playerid, COLOUR_DICA, "");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/combate", true) == 0 || strcmp(cmd, "/cbw", true) == 0 || strcmp(cmd, "/cb", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid, 16);
Arena[playerid] = 1;
ArenaTipo[playerid] = 6;
new rand = random(sizeof(RunPos));
SetPlayerPos(playerid, RunPos[rand][0], RunPos[rand][1], RunPos[rand][2]);
SetPlayerFacingAngle(playerid,RunPos[rand][3]);
SetPlayerInterior(playerid, 16);
SetCameraBehindPlayer(playerid);
ResetPlayerWeapons(playerid);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,100);
GivePlayerWeapon(playerid, 4, 2);
GivePlayerWeapon(playerid, 24, 9999);
GivePlayerWeapon(playerid, 25, 9999);
GivePlayerWeapon(playerid, 31, 9999);
GivePlayerWeapon(playerid, 34, 9999);
GivePlayerWeapon(playerid, 29, 9999);
GameTextForPlayer(playerid,"~r~COMBATE WALK!", 3000, 5);
CarregarCacar(playerid);
Streamer_Update(playerid);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para o COMBATE WALK. Quem vai? {FF0000}( /CBW )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_DICA, "");
SendClientMessage(playerid, COLOUR_DICA, "VOCÊ ESTÁ EM UM COMBATE, O OBJETIVO É MATAR TODOS QUE");
SendClientMessage(playerid, COLOUR_DICA, "VIREM AQUI, LEMBRANDO QUE, AO MATAR, SEU COLETE E SAUDE");
SendClientMessage(playerid, COLOUR_DICA, "SERÃO RECUPERADOS AUTOMATICAMENTE, ENTÃO MATE!");
SendClientMessage(playerid, COLOUR_DICA, "");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/snp", true) == 0 || strcmp(cmd, "/sp", true) == 0 || strcmp(cmd, "/sniper", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid, 17);
Arena[playerid] = 1;
ArenaTipo[playerid] = 7;
new rand = random(sizeof(SniperPos));
SetPlayerPos(playerid, SniperPos[rand][0], SniperPos[rand][1], SniperPos[rand][2]);
SetPlayerFacingAngle(playerid,SniperPos[rand][3]);
SetCameraBehindPlayer(playerid);
ResetPlayerWeapons(playerid);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,0);
GivePlayerWeapon(playerid, 4, 2);
GivePlayerWeapon(playerid, 34, 9999);
GameTextForPlayer(playerid,"~r~COMBATE SNIPER!", 3000, 5);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para o COMBATE SNIPER. Quem vai? {FF0000}( /SNP )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_DICA, "");
SendClientMessage(playerid, COLOUR_DICA, "VOCÊ ESTÁ EM UM COMBATE, O OBJETIVO É MATAR TODOS QUE");
SendClientMessage(playerid, COLOUR_DICA, "VIREM AQUI, LEMBRANDO QUE, AO MATAR, SUA SAUDE");
SendClientMessage(playerid, COLOUR_DICA, "SERÁ RECUPERADA AUTOMATICAMENTE, ENTÃO MATE!");
SendClientMessage(playerid, COLOUR_DICA, "");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/snp2", true) == 0 || strcmp(cmd, "/sp2", true) == 0 || strcmp(cmd, "/sniper2", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(SNP2Liberado == false) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: A arena SNP2 não está aberta para o uso");
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid, 23);
Arena[playerid] = 1;
ArenaTipo[playerid] = 7;
SNP2[playerid] = true;
new rand = random(sizeof(SniperPos));
SetPlayerPos(playerid, SniperPos[rand][0], SniperPos[rand][1], SniperPos[rand][2]);
SetCameraBehindPlayer(playerid);
SetPlayerFacingAngle(playerid,SniperPos[rand][3]);
ResetPlayerWeapons(playerid);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,0);
GivePlayerWeapon(playerid, 4, 2);
GivePlayerWeapon(playerid, 34, 9999);
GameTextForPlayer(playerid,"~r~COMBATE SNIPER 2!", 3000, 5);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para o COMBATE SNIPER 2. Quem vai? {FF0000}( /SNP2 )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_DICA, "");
SendClientMessage(playerid, COLOUR_DICA, "VOCÊ ESTÁ EM UM COMBATE, O OBJETIVO É MATAR TODOS QUE");
SendClientMessage(playerid, COLOUR_DICA, "VIREM AQUI, LEMBRANDO QUE, AO MATAR, SUA SAUDE");
SendClientMessage(playerid, COLOUR_DICA, "SERÁ RECUPERADA AUTOMATICAMENTE, ENTÃO MATE!");
SendClientMessage(playerid, COLOUR_DICA, "");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/x1w", true) == 0) {
	if(Duel[playerid] != 998) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você já está em um DUEL.");
	if(!IsPlayerSpawned(playerid)){return 1;}
	if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
	if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
	if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
	if(GetPlayerInterior(playerid) != 0 && DuelArena[playerid] == false) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
	if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
	if(Arena[playerid] == 1 && DuelArena[playerid] == false) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
	if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
	if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
	Arena[playerid] = 1;
	DuelArena[playerid] = true;
	Duel[playerid] = 999;
	SetPlayerInterior(playerid,1);
	SetPlayerVirtualWorld(playerid,playerid);
	SetPlayerPos(playerid,1403.6039,-20.7303,1000.9115);
	SetPlayerFacingAngle(playerid,92.2);

	new anuncio[500];
	format(anuncio,sizeof anuncio,"[X1W] {FFFFFF}%s {FF387A}criou um DUEL! Digite /ACEITAR {FFFFFF}%d.",GetName(playerid),playerid);
	SendClientMessageToAll(COLOUR_INFORMACAO,anuncio);
	return 1;
}

if(strcmp(cmd, "/sairx1w", true) == 0) {
	if(!IsPlayerSpawned(playerid)){return 1;}
	if(Duel[playerid] == 998) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não está em duel!");
	if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
	if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
	if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
	if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
	if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
	if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);

	DuelArena[playerid] = false;
	if(Duel[playerid] == 999)
	{
		SpawnPlayer(playerid);
		Duel[playerid] = 998;
		Arena[playerid] = 0;
		return 1;
	}

	new a[500];
	format(a,sizeof a,"[X1W] {998A9E}O player {FFFFFF}%s {998A9E}correu no meio do duel contra {FFFFFF}%s!",GetName(playerid),GetName(Duel[playerid]));
	Arena[playerid] = 0;
	SendClientMessageToAll(COLOUR_INFORMACAO,a);
	SpawnPlayer(Duel[playerid]);
	SpawnPlayer(playerid);
	return 1;
}

if(strcmp(cmd, "/duel", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(X1WCLOSED == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O X1W esta fechado para remoção de sangue e cadáveres");
if(X1W > 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Um duelo já está em progresso no X1W! Tente mais tarde!");
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
ResetAwayStatus(playerid);
AwaySeconds[playerid] = 0;
//if(GetPVarInt(playerid,"PVarFPS") < 20 && GetPVarInt(playerid,"PVarFPS") != 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Seu computador é lento demais para tirar x1 Walk. (Limite: 20 FPS)");
X1W = X1W+1;
RemoverTodosAttachsObj(playerid);
ArenaTipo[playerid] = 8;
Arena[playerid] = 1;
SetPlayerInterior(playerid,3);
SetPlayerVirtualWorld(playerid, 18);
RemoverTodosAttachsObj(playerid);
new rand = random(sizeof(WalkPos));
SetPlayerPos(playerid, WalkPos[rand][0], WalkPos[rand][1], WalkPos[rand][2]);
SetPlayerFacingAngle(playerid,WalkPos[rand][3]);
SetPlayerInterior(playerid, 1);
SetCameraBehindPlayer(playerid);
ResetPlayerWeapons(playerid);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,100);
GivePlayerWeapon(playerid, 4, 2);
GivePlayerWeapon(playerid, 25, 9999);
GivePlayerWeapon(playerid, 31, 9999);
GivePlayerWeapon(playerid, 34, 9999);
GivePlayerWeapon(playerid, 29, 9999);
GivePlayerWeapon(playerid, 24, 9999);
GameTextForPlayer(playerid,"~r~X1 WALK! ~n~~w~MANDA VER!", 3000, 5);
CarregarCacar(playerid);
Streamer_Update(playerid);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para o X1 WALK {FF0000}( /DUEL )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_INFORMACAO, "");
SendClientMessage(playerid, COLOUR_AVISO, "[AVISO]: Se ficar sem se movimentar por mais de um minuto no X1W será automaticamente kickado");
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Para sair do X1W digite /SAIR - Se ganhar o duelo, ganhará respawn automático");
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Bem-Vindo ao X1W! {FFFFFF}Uma arena especial para duelos entre 2 players com armas WALKING!");
SendClientMessage(playerid, COLOUR_INFORMACAO, "");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/x1s", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid, 600);
Arena[playerid] = 1;
ArenaTipo[playerid] = 100;
new rand = random(sizeof(DelegaciaPos));
SetPlayerInterior(playerid, 3);
SetPlayerPos(playerid, DelegaciaPos[rand][0], DelegaciaPos[rand][1], DelegaciaPos[rand][2]);
SetPlayerFacingAngle(playerid,DelegaciaPos[rand][3]);
SetCameraBehindPlayer(playerid);
ResetPlayerWeapons(playerid);
X1sArena[playerid]=true;
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,100);
GivePlayerWeapon(playerid, 34, 9999);
GameTextForPlayer(playerid,"~r~X1s!", 3000, 5);
CarregarCacar(playerid);
Streamer_Update(playerid);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para a arena um tiro mata (SNIPER). Quem vai? {FF0000}( /X1s )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_DICA, "");
SendClientMessage(playerid, COLOUR_DICA, "VOCÊ ESTÁ EM UMA ARENA DM, O OBJETIVO É MATAR TODOS QUE");
SendClientMessage(playerid, COLOUR_DICA, "VIREM AQUI, LEMBRANDO QUE, AO MATAR, SEU COLETE E SAUDE");
SendClientMessage(playerid, COLOUR_DICA, "SERÃO RECUPERADOS AUTOMATICAMENTE, ENTÃO MATE!");
SendClientMessage(playerid, COLOUR_DICA, "");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/combate2", true) == 0 || strcmp(cmd, "/cbr", true) == 0 || strcmp(cmd, "/cb2", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
RemoverTodosAttachsObj(playerid);
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid, 21);
Arena[playerid] = 1;
ArenaTipo[playerid] = 6;
new rand = random(sizeof(RunPos));
SetPlayerPos(playerid, RunPos[rand][0], RunPos[rand][1], RunPos[rand][2]);
SetPlayerFacingAngle(playerid,RunPos[rand][3]);
SetPlayerInterior(playerid, 15);
SetCameraBehindPlayer(playerid);
ResetPlayerWeapons(playerid);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,100);
GivePlayerWeapon(playerid, 22, 9999);
GivePlayerWeapon(playerid, 28, 9999);
GivePlayerWeapon(playerid, 26, 9999);
GameTextForPlayer(playerid,"~r~COMBATE RUN!", 3000, 5);
CarregarCacar(playerid);
Streamer_Update(playerid);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para o COMBATE RUN. Quem vai? {FF0000}( /CBR )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_DICA, "");
SendClientMessage(playerid, COLOUR_DICA, "VOCÊ ESTÁ EM UM COMBATE, O OBJETIVO É MATAR TODOS QUE");
SendClientMessage(playerid, COLOUR_DICA, "VIREM AQUI, LEMBRANDO QUE, AO MATAR, SEU COLETE E SAUDE");
SendClientMessage(playerid, COLOUR_DICA, "SERÃO RECUPERADOS AUTOMATICAMENTE, ENTÃO MATE!");
SendClientMessage(playerid, COLOUR_DICA, "");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}


//ARENA CAÇADA BY MOTOXEX
if(strcmp(cmd, "/arenac", true) == 0 || strcmp(cmd, "/cacar", true) == 0|| strcmp(cmd, "/arenacacar", true) == 0) {
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(Arena[playerid] == 1 || Arena[playerid] == 24) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
arenacacadaEsconder[playerid] = 1;
ResetAwayStatus(playerid);
AwaySeconds[playerid] = 0;
RemoverTodosAttachsObj(playerid);
Arena[playerid] = 1;
ArenaTipo[playerid] = 24;
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid, 150);
RemoverTodosAttachsObj(playerid);
new rand = random(sizeof(CacarPos));
SetPlayerPos(playerid, CacarPos[rand][0], CacarPos[rand][1], CacarPos[rand][2]);
SetPlayerFacingAngle(playerid,CacarPos[rand][3]);
ArenacOns++;
SetPlayerInterior(playerid, 0);
SetCameraBehindPlayer(playerid);
ResetPlayerWeapons(playerid);
SetPlayerHealth(playerid,100);
SetPlayerArmour(playerid,0);
GivePlayerWeapon(playerid, 34, 10);
GivePlayerWeapon(playerid, 24, 50);
if(arenacacadaEsconder[playerid]==1){
	CorCacada[playerid] = GetPlayerColor(playerid);
	SetPlayerColor(playerid, 0xFFFFFF00);
	NickEsconder[playerid]=1;
}
GameTextForPlayer(playerid,"~r~ARENA DE CACADA! ~n~~w~DE SEU MELHOR!", 3000, 5);
CarregarCacar(playerid);
Streamer_Update(playerid);
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF0000}%s {B5B5B5}foi para a CAÇADA{FF0000}( /arenac )", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SendClientMessage(playerid, COLOUR_INFORMACAO, "");
SendClientMessage(playerid, COLOUR_AVISO, "[AVISO]: Se ficar sem se movimentar por mais de um minuto na arena será automaticamente kickado");
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Para sair da arena CAÇADA digite /SAIR.");
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Para ver quantos players on nesta arena digite: /ARENACONS");
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Bem-Vindo a CAÇADA! {FFFFFF}Uma arena especial para duelos entre varios players com diversas armas!");
SendClientMessage(playerid, COLOUR_INFORMACAO, "");
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/arenacons", true) == 0 || strcmp(cmd, "/arenaconline", true) == 0|| strcmp(cmd, "/arenacplayers", true) == 0) {
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
if((Arena[playerid] == 1 || Arena[playerid] == 24) && ArenaTipo[playerid]!=24) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
format(string, sizeof(string), "[INFO - ARENA CAÇADA]: Nesta arena há {FFFFFF}%i {21CC21}online!", ArenacOns);
SendClientMessage(playerid, COLOUR_INFORMACAO, string);
ProgramarAntiFlood(playerid);
return 1;}

if(strcmp(cmd, "/mudar", true) == 0){
	new Float:vidam;
	GetPlayerHealth(playerid, vidam);
	if(vidam == 100){
		if(TemCarroPerto(playerid, 1.0))return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Voce nao pode usar /mudar proximo ou dentro de um veiculo!");
		TextDrawHideForPlayer(playerid, Textdraw26);
		TextDrawHideForPlayer(playerid, Textdraw25);
		TextDrawHideForPlayer(playerid, Textdraw27);
		TextDrawHideForPlayer(playerid, Textdraw28);
		TextDrawHideForPlayer(playerid, Textdraw29);
		TextDrawHideForPlayer(playerid, Textdraw30);
		if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está em um local em que o /mudar é bloqueado");
		if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
		SetPlayerHealth(playerid,0.0);ForceClassSelection(playerid);
		new pname[MAX_PLAYER_NAME];
		GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
		format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi mudar o Skin {CC3361}( /MUDAR )", pname);
		SendClientMessageToAll(COLOUR_TELEPORTE, string);
		ProgramarAntiFlood(playerid);
 	}
 	else{
 		ProgramarAntiFlood(playerid);
        SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você precisa estar com a vida cheia para usar o comando /MUDAR!");
	}
return 1;}

if(strcmp(cmdtext,"/pvcescolha",true)==0)
{
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,0x66CCFFAA,StringTable[8]);
new pvcescolha[1000];
strins(pvcescolha,"{B33434}[BRASIL]MUNDO DOS PIKAS [MdP]\n\n",strlen(pvcescolha));
strins(pvcescolha,"{CC3361}0 - RPGxCARROS\n\n",strlen(pvcescolha));
strins(pvcescolha,"{CC3361}1 - SNIPERxCARROS\n\n",strlen(pvcescolha));
strins(pvcescolha,"{CC3361}2 - RPGxMOTOS\n\n",strlen(pvcescolha));
strins(pvcescolha,"{CC3361}3 - SNIPERxMOTOS\n\n",strlen(pvcescolha));
strins(pvcescolha,"{00FF00}Escolha o modo para criar! /PVCESCOLHER\n\n",strlen(pvcescolha));
ShowPlayerDialog(playerid,8439, DIALOG_STYLE_MSGBOX, "{B33434}• PVC ESCOLHA •",pvcescolha, "Fechar", "");
return 1;
}

if(strcmp(cmdtext,"/creditos",true)==0)
{
new creditos[1000];
strins(creditos,"{B33434}[BRASIL]MUNDO DOS PIKAS [MdP]\n\n",strlen(creditos));
strins(creditos,"{CC3361}MotoXeX {999999}[DONO] [SCRIPTER] [MAPPER]\n\n",strlen(creditos));
strins(creditos,"{CC3361}Traknagem {999999}[SCRIPTER]\n\n",strlen(creditos));
strins(creditos,"{CC3361}DominiN {999999}[MAPPER]\n\n",strlen(creditos));
strins(creditos,"{CC3361}[MdB]RenaN {999999}[SCRIPTER]\n\n",strlen(creditos));
strins(creditos,"{CC3361}anjos_noturnos {999999}[TextDrawDeath]\n\n",strlen(creditos));
strins(creditos,"{00FF00}Obrigado por estar jogando no servidor!\n\n",strlen(creditos));
ShowPlayerDialog(playerid,8439, DIALOG_STYLE_MSGBOX, "{B33434}• CREDITOS •",creditos, "Fechar", "");
return 1;
}

if(strcmp(cmdtext,"/pvcajuda",true)==0 || strcmp(cmdtext,"/ajudapvc",true)==0)
{
new pvcajuda[1000];
strins(pvcajuda,"{B33434}[BRASIL]MUNDO DOS PIKAS [MdP]\n\n",strlen(pvcajuda));
strins(pvcajuda,"{CC3361}AJUDA PVC!!\n\n",strlen(pvcajuda));
strins(pvcajuda,"{CC3361}Para jogar basta aguardar o /pvc ser iniciado por um administrador ou aguardar de hora em hora!\n\n",strlen(pvcajuda));
strins(pvcajuda,"{CC3361}Dentro do /pvc há dois times, 'azul' e 'vermelho', um deles deverá matar os players que estao dirigindo os carros,\n\n",strlen(pvcajuda));
strins(pvcajuda,"{CC3361}e no time dos CARROS deverá derrubar os players que estão na plataforma!\n\n",strlen(pvcajuda));
strins(pvcajuda,"{CC3361}*Se você usar /kill, explodir o carro ou for morto, conta ponto ao time adversário!\n\n",strlen(pvcajuda));
strins(pvcajuda,"{00FF00}BOM JOGO!!\n\n",strlen(pvcajuda));
ShowPlayerDialog(playerid,8439, DIALOG_STYLE_MSGBOX, "{B33434}• AJUDA PVC •",pvcajuda, "Fechar", "");
return 1;
}

if(strcmp(cmdtext,"/planosadmins",true)==0 || strcmp(cmdtext,"/compraradm",true)==0 || strcmp(cmdtext,"/compraradmin",true)==0 || strcmp(cmdtext,"/planovip",true)==0 || strcmp(cmdtext,"/planosvip",true)==0)
{
new planos[1000];
strins(planos,"{B33434}[BRASIL]MUNDO DOS PIKAS [MdP]\n\n",strlen(planos));
strins(planos,"{CC3361}Adm Level 2 = {999999}R$15,00 (PROMOÇÃO)\n\n",strlen(planos));
strins(planos,"{CC3361}Adm Level 3 = {999999}R$20,00 (PROMOÇÃO)\n\n",strlen(planos));
strins(planos,"{CC3361}Adm Level 4 = {999999}R$30,00\n\n",strlen(planos));
strins(planos,"{CC3361}Adm Level 5 = {999999}R$38,00 (PROMOÇÃO)\n\n",strlen(planos));
strins(planos,"{CC3361}Para mais informações: {FFFFFF} deividi96_luiz\n\n",strlen(planos));
ShowPlayerDialog(playerid,8439, DIALOG_STYLE_MSGBOX, "{B33434}• PLANOS ADMINS •",planos, "Fechar", "");
return 1;
}

if(strcmp(cmdtext,"/vantagensvip",true)==0 || strcmp(cmdtext,"/vantagevip",true)==0 || strcmp(cmdtext,"/vantagemvips",true)==0 || strcmp(cmdtext,"/vipcmd",true)==0 || strcmp(cmdtext,"/cmdsvip",true)==0 || strcmp(cmdtext,"/vipcmds",true)==0)
{
	new vantagens[1000];
			strins(vantagens,"{B33434}Comandos [VIP]\n\n\n",strlen(vantagens));
			strins(vantagens,"{CC3361}/GETINFO {FFFFFF}---{CC3361} /WEAPS \n\n",strlen(vantagens));
			strins(vantagens,"{CC3361}/INFOACC{FFFFFF} ---{CC3361} /ADMINAREA\n\n",strlen(vantagens));
			strins(vantagens,"{CC3361}/LSPEC {FFFFFF}- {CC3361}/LSPECOFF\n\n",strlen(vantagens));
			strins(vantagens,"{CC3361}/SAVESKIN {FFFFFF}--- {CC3361}/USESKIN\n\n",strlen(vantagens));
			strins(vantagens,"{CC3361}/LP {FFFFFF}-{CC3361} /ASAY\n\n",strlen(vantagens));
			strins(vantagens,"{CC3361}/DOUNTSKIN {FFFFFF}--- {CC3361}/LTC\n\n",strlen(vantagens));
			strins(vantagens,"{CC3361}/MINIGUNS {FFFFFF}---{CC3361} /PING\n\n",strlen(vantagens));
			strins(vantagens,"{CC3361}/REPORTS {FFFFFF}--- {CC3361}/richlist\n\n",strlen(vantagens));
	        strins(vantagens,"{CC3361}/SETMYTIME {FFFFFF}--- {CC3361} @ (CHAT VIP)\n\n",strlen(vantagens));
	        strins(vantagens,"{CC3361}/SPAWN {FFFFFF}---{CC3361}/JETPACK\n\n",strlen(vantagens));
  ShowPlayerDialog(playerid,8439, DIALOG_STYLE_MSGBOX, "{B33434}• VANTAGENS VIP •",vantagens, "Fechar", "");
	return 1;
}

if(strcmp(cmdtext,"/regrasadm",true)==0 || strcmp(cmdtext,"/admregras",true)==0 || strcmp(cmdtext,"/adminregras",true)==0)
{
new regrasadm[1000];
strins(regrasadm,"{B33434}[BRASIL]MUNDO DOS PIKAS [MdP]\n\n",strlen(regrasadm));
strins(regrasadm,"{CC3361}1º - Nunca ficar sem TAG [MdP]!\n\n",strlen(regrasadm));
strins(regrasadm,"{CC3361}2º - Não abusar dos players!\n\n",strlen(regrasadm));
strins(regrasadm,"{CC3361}3º - Não dar BAN ou AVISOS sem motivos!\n\n",strlen(regrasadm));
strins(regrasadm,"{CC3361}4º - Quando receber REPORTS olhar o mais rápido possivel!\n\n",strlen(regrasadm));
strins(regrasadm,"{CC3361}5º - Sem floods no serv ou chat ADM!\n\n",strlen(regrasadm));
strins(regrasadm,"{CC3361}6º - Divulgar o serv diariamente (ajudara a subir de level)!\n\n",strlen(regrasadm));
ShowPlayerDialog(playerid,8439, DIALOG_STYLE_MSGBOX, "{B33434}• REGRAS ADMINS •",regrasadm, "Fechar", "");
return 1;
}

if(strcmp(cmdtext,"/contatos",true)==0)
{
new creditos[1000];
strins(creditos,"{B33434}[BRASIL]MUNDO DOS PIKAS [MdP]\n\n",strlen(creditos));
strins(creditos,"{CC3361}MotoXeX = Skype: {FFFFFF}deividi96_luiz\n\n",strlen(creditos));
ShowPlayerDialog(playerid,8439, DIALOG_STYLE_MSGBOX, "{B33434}• CONTATOS •",creditos, "Fechar", "");
return 1;
}

if(strcmp(cmdtext,"/teles",true)==0 || strcmp(cmdtext,"/teleports",true)==0 || strcmp(cmdtext,"/tele",true)==0)
{
new creditos[1000];
strins(creditos,"{B33434}[BRASIL]MUNDO DOS PIKAS [MdP]\n\n",strlen(creditos));
strins(creditos,"{00FF00}Teleportes:\n",strlen(creditos));
strins(creditos,"{FFFFFF}/LB /EB /FC /LCY /BCH /CBC /USF /ESF /FDD /OSLV /BARCO /HD\n",strlen(creditos));
strins(creditos,"{FFFFFF}/ASF /CC /SFS /PT /BL /FV /BS /MGM /PC /DLM /BB /CA /BAR /WG\n",strlen(creditos));
strins(creditos,"{FFFFFF}/AEROSF /MTLV /AEROLV /AEROAB /GROVE /LV /AVENIDA /DESERTO /EC\n",strlen(creditos));
strins(creditos,"{FFFFFF}/TB /PRAIA /RALLY /CHILLIAD /PQLV /SUBAGUA /EXSF /RH /AREA51\n",strlen(creditos));
strins(creditos,"{FFFFFF}/LS /FZ /RR /PILAR /DRIFT /MORRO /RANCHO /RM /RE /ESF1 /PK\n",strlen(creditos));
strins(creditos,"{FFFFFF}/PK2 /PK3 /PK4 /PK5 /PK6 /JUMP /TV /LPS /CSF /PSF /PSSF /VSF /PS\n",strlen(creditos));
strins(creditos,"{FFFFFF}/CGSF /DROP /DROP2 /DROP3 /DROP4 /DROP5 /DROP6 /DROP7 /DROP8\n",strlen(creditos));
strins(creditos,"{FFFFFF}/DROP10 /PRSF /RCSF /CTLS /MLS /EGLS /MDLS /CMTLS /VNLS /TVLS /MR\n",strlen(creditos));
strins(creditos,"{FFFFFF}/MARLS /CDLS /DQLS /VRCK /NVSF /DTRG /EOLV /LSPT /RNLV /TPVS\n",strlen(creditos));
strins(creditos,"{FFFFFF}/ESVS /NVP /CMLV /CGF /ETLV /SNKF /JRZ /IDSF /FDLS /SK8 /PQLS\n",strlen(creditos));
strins(creditos,"{FFFFFF}/FVLS /TFLV /MNLV /PDS /RSLV /ULV /AELV /DQLS2 /VSH /CWP /CTLV\n",strlen(creditos));
strins(creditos,"{FFFFFF}/ET /ET2 /RM3 /CLUBE /RM4 /RM5 /LABIRINTO /NRG /NRG2 /NRG3\n",strlen(creditos));
strins(creditos,"{FFFFFF}/STUNT /STUNTPRO /STUNTPRO2 /SPU /CC2 /PKSA /CCM /DERBY\n",strlen(creditos));
ShowPlayerDialog(playerid,8439, DIALOG_STYLE_MSGBOX, "{B33434}• Teles •",creditos, "Fechar", "");
return 1;
}

if(strcmp(cmdtext,"/cmdnovo",true)==0 || strcmp(cmdtext,"/novoscmds",true)==0 || strcmp(cmdtext,"/novoscmd",true)==0|| strcmp(cmdtext,"/comandosnovos",true)==0)
{
new novoscmd[1000];
strins(novoscmd,"{B33434}[BRASIL]MUNDO DOS PIKAS [MdP]\n\n",strlen(novoscmd));
strins(novoscmd,"{00FF00}Novos comandos:\n",strlen(novoscmd));
strins(novoscmd,"{FFFFFF}/ARENAC /X1s /DUEL /PVC /PL\n",strlen(novoscmd));
ShowPlayerDialog(playerid,8439, DIALOG_STYLE_MSGBOX, "{B33434}• Teles •",novoscmd, "Fechar", "");
return 1;
}

if(strcmp(cmdtext,"/seradm",true)==0 || strcmp(cmdtext,"/seradmin",true)==0 || strcmp(cmdtext,"/comoseradm",true)==0)
{
new creditos[1000];
strins(creditos,"{B33434}[BRASIL]MUNDO DOS PIKAS [MdP]\n\n",strlen(creditos));
strins(creditos,"{00FF00}Ser ADM:\n\n",strlen(creditos));
strins(creditos,"{00FF2F}Dica 1: {FFFFFF}Ser jogador ativo no servidor!\n",strlen(creditos));
strins(creditos,"{00FF2F}Dica 2: {FFFFFF}Divulgar o servidor! (PARA TODOS)\n",strlen(creditos));
strins(creditos,"{00FF2F}Dica 3: {FFFFFF}Não insistir para ganhar ADM, se merecer saberá!\n",strlen(creditos));
strins(creditos,"{00FF2F}Dica 4: {FFFFFF}Respeite todos, mesmo sem ADM online!\n",strlen(creditos));
strins(creditos,"{00FF2F}Dica 5: {FFFFFF}Ajude players novos!\n",strlen(creditos));
strins(creditos,"{00FF2F}Dica 6: {FFFFFF}Não pode ser ADM em outro servidor!\n",strlen(creditos));
strins(creditos,"{00FF2F}Dica 7: {FFFFFF}Não usar MOD que lhe de vantagem!\n",strlen(creditos));
strins(creditos,"{00FF2F}Dica 8: {FFFFFF}Nunca ser abuser dos players!\n",strlen(creditos));
strins(creditos,"{00FF2F}Dica 9: {FFFFFF}Saber os CMDS necessários para level 1 e 2!\n",strlen(creditos));
strins(creditos,"{00FF2F}Dica 10: {FFFFFF}Se merecer subirá de cargo rápido!\n",strlen(creditos));
strins(creditos,"{00FF2F}Dica 11: {FFFFFF}Sempre estamos verificando para saber se estão ativos no serv!\n",strlen(creditos));
strins(creditos,"{00FF2F}Dica 12: {FFFFFF}Boa sorte!\n",strlen(creditos));
ShowPlayerDialog(playerid,8439, DIALOG_STYLE_MSGBOX, "{B33434}• Ser ADM •",creditos, "Fechar", "");
return 1;
}

//NENHUM COMANDO
SendClientMessage(playerid, COLOUR_CINZA,"{FF0000}[ERRO]: Comando inexistente. Digite {FFFFFF}/comandos {FF0000}para obter a lista de comandos.");
GameTextForPlayer(playerid,"~r~/COMANDOS",3000,3);
return 1;
}

//------------------------------------------------------------------------------------------------------

forward Cont(p1,p2,pos);
public Cont(p1,p2,pos)
{
	switch(pos)
	{
		case 2:
		{
			GameTextForPlayer(p1,"2",1000,6);
			GameTextForPlayer(p2,"2",1000,6);
			PlayerPlaySound(p2,1056,0,0,0);
			PlayerPlaySound(p1,1056,0,0,0);
			SetTimerEx("Cont",1000,false,"ddd",p1,p2,1);
			SetCameraBehindPlayer(p1);
			SetCameraBehindPlayer(p2);
		}
		case 1:
		{
			GameTextForPlayer(p1,"1",1000,6);
			GameTextForPlayer(p2,"1",1000,6);
			PlayerPlaySound(p2,1056,0,0,0);
			PlayerPlaySound(p1,1056,0,0,0);
			SetTimerEx("Cont",1000,false,"ddd",p1,p2,0);
		}
		case 0:
		{
			GameTextForPlayer(p1,"GO",1000,6);
			GameTextForPlayer(p2,"GO",1000,6);
			PlayerPlaySound(p2,1057,0,0,0);
			PlayerPlaySound(p1,1057,0,0,0);
			TogglePlayerControllable(p1,1);
			TogglePlayerControllable(p2,1);

			ResetPlayerWeapons(p1);
			SetPlayerHealth(p1,100.0);
			SetPlayerArmour(p1,100.0);
			GivePlayerWeapon(p1, 25, 5000);
			GivePlayerWeapon(p1, 34, 5000);
			GivePlayerWeapon(p1, 24, 5000);

			ResetPlayerWeapons(p2);
			SetPlayerHealth(p2,100.0);
			SetPlayerArmour(p2,100.0);
			GivePlayerWeapon(p2, 25, 5000);
			GivePlayerWeapon(p2, 34, 5000);
			GivePlayerWeapon(p2, 24, 5000);
		}
	}
	return 1;
}

forward ContPVC(playerid, pos);
public ContPVC(playerid, pos)
{
	switch(pos)
	{
		case 2:
		{
			GameTextForPlayer(playerid,"2",1000,6);
			PlayerPlaySound(playerid,1056,0,0,0);
			SetTimerEx("ContPVC",1000,false,"ddd",playerid,1);
			SetCameraBehindPlayer(playerid);
		}
		case 1:
		{
			GameTextForPlayer(playerid,"1",1000,6);
			PlayerPlaySound(playerid,1056,0,0,0);
			SetTimerEx("ContPVC",1000,false,"ddd",playerid,0);
		}
		case 0:
		{
			GameTextForPlayer(playerid,"GO",1000,6);
			PlayerPlaySound(playerid,1057,0,0,0);
			TogglePlayerControllable(playerid,1);
			TextDrawHideForPlayer(playerid, Textdraw25);
			TextDrawHideForPlayer(playerid, Textdraw27);
			TextDrawHideForPlayer(playerid, Textdraw28);
			TextDrawHideForPlayer(playerid, Textdraw29);
			TextDrawHideForPlayer(playerid, Textdraw30);
		}
	 }
	return 1;
}

forward ContPL(p1,pos);
public ContPL(p1,pos)
{
	switch(pos)
	{
		case 2:
		{
			GameTextForPlayer(p1,"2",1000,6);
			PlayerPlaySound(p1,1056,0,0,0);
			SetTimerEx("ContPL",1000,false,"ddd",p1,1);
			SetCameraBehindPlayer(p1);
		}
		case 1:
		{
			GameTextForPlayer(p1,"1",1000,6);
			PlayerPlaySound(p1,1056,0,0,0);
			SetTimerEx("ContPL",1000,false,"ddd",p1,0);
		}
		case 0:
		{
			GameTextForPlayer(p1,"GO",1000,6);
			PlayerPlaySound(p1,1057,0,0,0);
			TogglePlayerControllable(p1,1);
		}
	}
	return 1;
}

forward Prender(playerid,idmotivo,minutos);
public Prender(playerid,idmotivo,minutos)
{
new tempoms = minutos*1000*60;
TogglePlayerControllable(playerid,0);
SetPlayerVirtualWorld(playerid, 9511);
SetPlayerPos(playerid,197.6661,173.8179,1003.0234);
SetPlayerInterior(playerid,3);
SetCameraBehindPlayer(playerid);
ResetPlayerWeapons(playerid);
CallRemoteFunction("GivePlayerCash", "ii", playerid, -11000);
switch(idmotivo){
case 0: format(cadeiastring,sizeof(cadeiastring),"~r~PRESO POR %i MINUTOS", minutos);
case 1: format(cadeiastring,sizeof(cadeiastring),"~r~PRESO POR %i MINUTOS~n~~n~~y~FEZ DB COM GODCAR", minutos);
case 2: format(cadeiastring,sizeof(cadeiastring),"~r~PRESO POR %i MINUTOS~n~~n~~y~ATIROU DE VEICULO", minutos);
case 3: format(cadeiastring,sizeof(cadeiastring),"~r~PRESO POR %i MINUTOS~n~~n~~y~MATOU NA HELICE", minutos);}
GameTextForPlayer(playerid,cadeiastring,6000,3);
KillTimer(TimerSoltar[playerid]);
TimerSoltar[playerid] = SetTimerEx("soltar",tempoms,0, "i", playerid);
preso[playerid] = 1;
return 1;
}


forward soltar(playerid);
public soltar(playerid)
{
//SpawnPlayer(playerid);
preso[playerid] = 0;
GameTextForPlayer(playerid,"~g~SOLTO DA CADEIA!",6000,3);
SpawnPlayer(playerid);
}

forward timed_spawn(playerid);
public timed_spawn(playerid)
{
SpawnPlayer(playerid);
}

forward Carregar(playerid);
public Carregar(playerid)
{
if(LoaderFreezer == 0) return 1;
new loadtime;
if(GetPlayerPing(playerid) < 2000) loadtime = 1000+GetPlayerPing(playerid); else loadtime = 2000;
TogglePlayerControllable(playerid,0);
GameTextForPlayer(playerid, "~y~CARREGANDO...",loadtime, 5);
KillTimer(TeleLockTimer[playerid]);
TeleLockTimer[playerid] = SetTimerEx("Destravar",loadtime,0, "i", playerid);
return 1;
}


forward CarregarCacar(playerid);
public CarregarCacar(playerid)
{
if(LoaderFreezer == 0) return 1;
new loadtime;
if(GetPlayerPing(playerid) < 2000) loadtime = 1000+GetPlayerPing(playerid); else loadtime = 2000;
TogglePlayerControllable(playerid,0);
GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~-~y~]~g~-~g~GO~g~-~y~]~g~-",1000,3);
KillTimer(TeleLockTimer[playerid]);
TeleLockTimer[playerid] = SetTimerEx("Destravar",loadtime,0, "i", playerid);
return 1;
}

forward Destravar(playerid);
public Destravar(playerid)
{
TogglePlayerControllable(playerid,1);
return 1;
}

public OnPlayerSpawn(playerid)
{
if(arenacacadaEsconder[playerid]==1){
	SetPlayerColor(playerid, CorCacada[playerid]);
	NickEsconder[playerid]=0;
	arenacacadaEsconder[playerid]=0;
	ArenacOns--;
}
    new String[128];
	format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
	PlayerDados[playerid][Membro] = DOF2_GetInt(String, "Membro");
	PlayerDados[playerid][Lider] = DOF2_GetInt(String, "Lider");
	PlayerDados[playerid][Cargo] = DOF2_GetInt(String, "Cargo");
	if(ContaExiste(playerid))
	{
	    format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
	    PlayerDados[playerid][Lider] = DOF2_GetInt(String, "Lider");
	    PlayerDados[playerid][Membro] = DOF2_GetInt(String, "Membro");
	    PlayerDados[playerid][Cargo] = DOF2_GetInt(String, "Cargo");
	    format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Membro]);
	    if(!DOF2_FileExists(String)){
	        PlayerDados[playerid][Membro] = 0;
	        PlayerDados[playerid][Cargo] = 0;
 		}
	}
	if(!ContaExiste(playerid)){
	    format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
		DOF2_CreateFile(String);
		DOF2_SetInt(String, "Lider", PlayerDados[playerid][Lider]);
		DOF2_SetInt(String, "Membro", PlayerDados[playerid][Membro]);
		DOF2_SetInt(String, "Cargo", PlayerDados[playerid][Cargo]);
	}

Duel[playerid] = 998;
X1sArena[playerid] = false;
mortohs[playerid] = false;
StopFly(playerid);
ccolete[playerid] = 0;
vida[playerid] = 0;
SetPVarInt(playerid,"InMaze",0);
TextDrawHideForAll(Textdraw25);
TextDrawHideForAll(Textdraw26);
SNP2[playerid] = false;
ChamadoParaX1Por[playerid] = -1;
CX1Tipo[playerid] = 0;
AFK[playerid] = false;
cmdtick[playerid] = 0;
Arena[playerid] = 0;
Arena2[playerid] = 0;
ArenaKills[playerid] = 0;
ArenaKills2[playerid] = 0;
if(ArenaTipo[playerid] == 3){X1 = X1-1;ArenaTipo[playerid] = 0;} //X1 RUN
if(ArenaTipo[playerid] == 8){X1W = X1W-1;ArenaTipo[playerid] = 0;} //X1 WALK
KillTimer(TimerSoltar[playerid]);
ArenaTipo[playerid] = 0;
Reparar[playerid] = 0;
NoEvento[playerid] = 0;
VPlayerMissao[playerid] = 0;
DistanciaMis[playerid] = 0;
DistanciaMis2[playerid] = 0;
StuntSuperSpeed[playerid] = false;

StopKillSpree(playerid);

if(cor[playerid] != 0){
SetPlayerColor(playerid, cor[playerid]);}

if(skin[playerid] != 0){
SetPlayerSkin(playerid, skin[playerid]);}


SetCameraBehindPlayer(playerid);
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid, 0);
SetPlayerInterior(playerid,0);
GivePlayerWeapon(playerid,4,0);
if(MostrandoStatus[playerid] == 1){TextDrawShowForPlayer(playerid,Status[playerid]);}
TextDrawHideForPlayer(playerid, TDEditor_TD[0]);
TextDrawHideForPlayer(playerid, TDEditor_TD[1]);
TextDrawHideForPlayer(playerid, TDEditor_TD[2]);
TextDrawHideForPlayer(playerid, TDEditor_TD[3]);
TextDrawHideForPlayer(playerid, TDEditor_TD[4]);
TextDrawHideForPlayer(playerid, TDEditor_TD[5]);
TextDrawHideForPlayer(playerid, TDEditor_TD[6]);
TextDrawHideForPlayer(playerid, Textdraw7);
TextDrawShowForPlayer(playerid, Textdraw8);
TextDrawShowForPlayer(playerid, Textdraw10);
TextDrawShowForPlayer(playerid, Textdraw1);
TextDrawShowForPlayer(playerid, Textdraw3);
TextDrawHideForPlayer(playerid, TxDNotificador);
TextDrawShowForPlayer(playerid, TxDNotificador);
//PlayerPlaySound( playerid, 1188, 0.0, 0.0, 0.0 );
SetPlayerHealth(playerid,100.0);
SetPlayerArmour(playerid,0.0);

SetCameraBehindPlayer(playerid);
SetPlayerInterior(playerid,0);
SetPlayerVirtualWorld(playerid, 0);
SetPlayerInterior(playerid,0);
GivePlayerWeapon(playerid,4,0);
if(MostrandoStatus[playerid] == 1){TextDrawShowForPlayer(playerid,Status[playerid]);}
TextDrawHideForPlayer(playerid, TDEditor_TD[0]);
TextDrawHideForPlayer(playerid, TDEditor_TD[1]);
TextDrawHideForPlayer(playerid, TDEditor_TD[2]);
TextDrawHideForPlayer(playerid, TDEditor_TD[3]);
TextDrawHideForPlayer(playerid, TDEditor_TD[4]);
TextDrawHideForPlayer(playerid, TDEditor_TD[5]);
TextDrawHideForPlayer(playerid, TDEditor_TD[6]);
TextDrawShowForPlayer(playerid, Textdraw8);
TextDrawShowForPlayer(playerid, Textdraw10);
TextDrawShowForPlayer(playerid, Textdraw1);
TextDrawHideForPlayer(playerid, texto1);
TextDrawHideForPlayer(playerid, texto9);
TextDrawHideForPlayer(playerid, topblack);
TextDrawHideForPlayer(playerid, bottomblack);
//==================================================
TextDrawHideForPlayer(playerid, texto8);
TextDrawShowForPlayer(playerid, Textdraw3);
TextDrawHideForPlayer(playerid, TxDNotificador);
TextDrawShowForPlayer(playerid, TxDNotificador);
//PlayerPlaySound( playerid, 1188, 0.0, 0.0, 0.0 );
SetPlayerHealth(playerid,100.0);
SetPlayerArmour(playerid,0.0);

//SPAWNS
if(PlayerCustomSpawn[playerid] == 1)
{
SetPlayerInterior(playerid, PlayerCustomSpawn_I[playerid]);
SetPlayerFacingAngle(playerid,PlayerCustomSpawn_F[playerid]);
SetPlayerPos(playerid,PlayerCustomSpawn_X[playerid],PlayerCustomSpawn_Y[playerid],PlayerCustomSpawn_Z[playerid]);
SetCameraBehindPlayer(playerid);
if(PlayerDados[playerid][Membro] == 0) SendClientMessage(playerid, COLOUR_DICA,"[INFO]: Para nascer no local padrão digite: /MSP");
}else{
new rand = random(sizeof(BloodySpawns));
SetPlayerPos(playerid, BloodySpawns[rand][0], BloodySpawns[rand][1], BloodySpawns[rand][2]);
SetPlayerFacingAngle(playerid,BloodySpawns[rand][3]);
SetCameraBehindPlayer(playerid);
if(PlayerDados[playerid][Membro] == 0) SendClientMessage(playerid, COLOUR_DICA,"[INFO]: Você pode escolher um local para nascer digitando: /MSP");
}

//RESETAR ARMAS
ResetPlayerWeapons(playerid);

// SOCO E SOCO INGLES
new weapons_slot_00=random(2);
switch(weapons_slot_00)
{
case 0:GivePlayerWeapon(playerid, 0, 1);
case 1:GivePlayerWeapon(playerid, 1, 1);
}

// BENGALA FACA ETC
new weapons_slot_01=random(8);
switch(weapons_slot_01)
{
case 0:GivePlayerWeapon(playerid, 2, 1);
case 1:GivePlayerWeapon(playerid, 3, 1);
case 2:GivePlayerWeapon(playerid, 4, 1);
case 3:GivePlayerWeapon(playerid, 5, 1);
case 4:GivePlayerWeapon(playerid, 6, 1);
case 5:GivePlayerWeapon(playerid, 7, 1);
case 6:GivePlayerWeapon(playerid, 8, 1);
case 7:GivePlayerWeapon(playerid, 9, 1);
}

// EXPLOSIVOS
new weapons_slot_08=random(2);
switch(weapons_slot_08)
{
case 0:GivePlayerWeapon(playerid, 16, 15);
//case 2:GivePlayerWeapon(playerid, 18, 3); // MOLOTOV
case 1:GivePlayerWeapon(playerid, 39, 15);
}

// PISTOLAS
new weapons_slot_02=random(4);
switch(weapons_slot_02)
{
case 0:GivePlayerWeapon(playerid, 22, 220);
case 1:GivePlayerWeapon(playerid, 23, 220);
case 2:GivePlayerWeapon(playerid, 24, 220);
case 3:GivePlayerWeapon(playerid, 24, 220);
}

// METRALHAS
new weapons_slot_04=random(3);
switch(weapons_slot_04)
{
case 0:GivePlayerWeapon(playerid, 28, 2500);
case 1:GivePlayerWeapon(playerid, 29, 2500);
case 2:GivePlayerWeapon(playerid, 32, 2500);
}

// ASSALTO
new weapons_slot_05=random(2);
switch(weapons_slot_05)
{
case 0:GivePlayerWeapon(playerid, 30, 1000);
case 1:GivePlayerWeapon(playerid, 31, 1000);
}

// RIFLES
new weapons_slot_06=random(2);
switch(weapons_slot_06)
{
case 0:GivePlayerWeapon(playerid, 33, 100);
case 1:GivePlayerWeapon(playerid, 34, 100);
}

// GAS
new weapons_slot_09=random(2);
switch(weapons_slot_09)
{
case 0:GivePlayerWeapon(playerid, 41, 2000);
case 1:GivePlayerWeapon(playerid, 42, 2000);
}

// SHOTGUNS
new weapons_slot_03=random(3);
switch(weapons_slot_03)
{
case 0:GivePlayerWeapon(playerid, 25, 880);
case 1:GivePlayerWeapon(playerid, 26, 880);
case 2:GivePlayerWeapon(playerid, 27, 880);
}

SetPlayerTeam(playerid, 255);
SetPlayerTeam(playerid, 255);

//Nascer com colete
if(NascerComColete[playerid] == true){
if(CallRemoteFunction("GetPlayerCash", "i", playerid) >= 5000){
CallRemoteFunction("GivePlayerCash", "ii", playerid, -5000);
SetPlayerArmour(playerid,100.0);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você nasceu com colete por $5000 {C1C1C1}Desabilitar: /ncc");}else{
SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Dinheiro insuficiente para nascer com colete {C1C1C1}Desabilitar: /ncc");}}

if(NascerColeteGratis[playerid] == true){
SetPlayerArmour(playerid,100.0);
}

if(NascerComKw[playerid] == true){
if(CallRemoteFunction("GetPlayerCash", "i", playerid) >= 15000){
CallRemoteFunction("GivePlayerCash", "ii", playerid, -15000);
GivePlayerWeapon(playerid, 4, 2);
GivePlayerWeapon(playerid, 25, 999);
GivePlayerWeapon(playerid, 31, 999);
GivePlayerWeapon(playerid, 34, 999);
GivePlayerWeapon(playerid, 29, 999);
GivePlayerWeapon(playerid, 24, 999);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você nasceu com Kit Walk por $15000 {C1C1C1}Desabilitar: /nkw");}else{
SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Dinheiro insuficiente para nascer com Kit Walk {C1C1C1}Desabilitar: /nkw");}}

if(NascerComKr[playerid] == true){
if(CallRemoteFunction("GetPlayerCash", "i", playerid) >= 15000){
CallRemoteFunction("GivePlayerCash", "ii", playerid, -15000);
GivePlayerWeapon(playerid, 4, 2);
GivePlayerWeapon(playerid, 22, 999);
GivePlayerWeapon(playerid, 28, 999);
GivePlayerWeapon(playerid, 26, 999);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você nasceu com Kit Run por $15000 {C1C1C1}Desabilitar: /nkr");}else{
SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Dinheiro insuficiente para nascer com Kit Run {C1C1C1}Desabilitar: /nkr");}}

if(NascerComTp[playerid] == true){
if(CallRemoteFunction("GetPlayerCash", "i", playerid) >= 30000){
CallRemoteFunction("GivePlayerCash", "ii", playerid, -30000);
GivePlayerWeapon(playerid, 4, 2);
GivePlayerWeapon(playerid, 16, 999);
GivePlayerWeapon(playerid, 24, 999);
GivePlayerWeapon(playerid, 26, 999);
GivePlayerWeapon(playerid, 28, 999);
GivePlayerWeapon(playerid, 31, 999);
GivePlayerWeapon(playerid, 34, 999);
GivePlayerWeapon(playerid, 31, 999);
GivePlayerWeapon(playerid, 41, 999);
GivePlayerWeapon(playerid, 46, 999);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você nasceu com Kit Top por $30000 {C1C1C1}Desabilitar: /nkt");}else{
SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Dinheiro insuficiente para nascer com Kit Top {C1C1C1}Desabilitar: /nkt");}}

if(NascerComKitGuerra[playerid] == true){
if(CallRemoteFunction("GetPlayerCash", "i", playerid) >= 10000){
CallRemoteFunction("GivePlayerCash", "ii", playerid, -10000);
GivePlayerWeapon(playerid, 22, 300);
GivePlayerWeapon(playerid, 28, 300);
GivePlayerWeapon(playerid, 31, 300);
GivePlayerWeapon(playerid, 16, 10);
GivePlayerWeapon(playerid, 34, 100);
GivePlayerWeapon(playerid, 4, 2);
GivePlayerWeapon(playerid, 42, 100);
GivePlayerWeapon(playerid, 26, 300);
SetPlayerArmour(playerid,100.0);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Você nasceu com Kit Guerra por $10000 {C1C1C1}Desabilitar: /nck");}else{
SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Dinheiro insuficiente para nascer com Kit {C1C1C1}Desabilitar: /nck");}}

    if(Txverifica[playerid] == 0){
		TextDrawHideForPlayer(playerid, Textdraw8);
		TextDrawHideForPlayer(playerid, TxDNotificador);
		TextDrawHideForPlayer(playerid, Textdraw3);
		TextDrawHideForPlayer(playerid, Textdraw10);
		TextDrawHideForPlayer(playerid,Status[playerid]);
		SendClientMessage(playerid, COLOUR_INFORMACAO, "{00FF15}[INFO]: Voce esta com os TextDraw da tela desativado. Para ativar /TXON!");
	}


 if(PlayerDados[playerid][Membro] > 0){
		format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Membro]);
	    if(DOF2_FileExists(String)) 	{
	 	    new str[100];
			format(str, sizeof(str), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Membro]);
	 	    if(DOF2_IsSet(String, "Skin")) SetPlayerSkin(playerid, ArquivoGangInt(playerid, "Skin"));
	 	    if(DOF2_IsSet(String, "SpawnX") && DOF2_IsSet(String, "SpawnY") && DOF2_IsSet(String, "SpawnZ")) SetPlayerPos(playerid, ArquivoGangInt(playerid, "SpawnX"), ArquivoGangInt(playerid, "SpawnY"), ArquivoGangInt(playerid, "SpawnZ"));
		}
	}
	
if(AAD_Team[playerid] == 1 && AAD_EmProgresso == 1 && AAD_Vai[playerid] == 1){AAD_SpawnPlayer_1(playerid);}
if(AAD_Team[playerid] == 2 && AAD_EmProgresso == 1 && AAD_Vai[playerid] == 1){AAD_SpawnPlayer_2(playerid);}

if(PVC_Team[playerid] == 1 && PVC_EmProgresso == 1 && PVC_Vai[playerid] == 1){PVC_SpawnPlayer_1(playerid);}
if(PVC_Team[playerid] == 2 && PVC_EmProgresso == 1 && PVC_Vai[playerid] == 1){PVC_SpawnPlayer_2(playerid);}

if(PL_Team[playerid] == 1 && PL_EmProgresso == 1 && PL_Vai[playerid] == 1){PL_SpawnPlayer_1(playerid);}
if(PL_Team[playerid] == 2 && PL_EmProgresso == 1 && PL_Vai[playerid] == 1){PL_SpawnPlayer_2(playerid);}

return 1;}

stock ConnectedPlayers()
{
	new Connected;
	for(new i; i < GetMaxPlayers(); i++)if(IsPlayerConnected(i)){Connected++;}
	return Connected;
}



stock CheckAndShowScoreMarks(playerid)
{
new pscore = GetPlayerScore(playerid);
new bool:continuar = false;
if(pscore == 200 ||pscore == 1000 ||pscore == 5000 ||pscore == 10000 ||pscore == 15000 ||pscore == 20000 ||pscore == 25000 ||pscore == 30000 ||pscore == 35000 ||pscore == 40000 ||pscore == 45000 ||pscore == 50000 ||pscore == 55000 ||pscore == 60000) continuar = true;
if(continuar == false) return 1;

new scstring[100],pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);

	switch(pscore)
	{
	case 50:         format(scstring, sizeof(scstring), "[INFO]: %s nada mal, mas ainda precisa melhorar!",pname);
	case 200: 		 format(scstring, sizeof(scstring), "[INFO]: %s não é mais noob! Alcançou 200 de score!",pname);
	case 1000:       format(scstring, sizeof(scstring), "[INFO]: %s está ficando bom! Alcançou 1000 de score!",pname);
	case 5000:       format(scstring, sizeof(scstring), "[INFO]: %s está botando pra foder! Alcançou 5000 de score!",pname);
	case 10000:      format(scstring, sizeof(scstring), "[INFO]: %s está ownando geral! Alcançou 10000 de score!",pname);
	case 15000:      format(scstring, sizeof(scstring), "[INFO]: Cuidado com %s! Ele alcançou 15000 de score!",pname);
	case 20000:      format(scstring, sizeof(scstring), "[INFO]: %s esta matando sem remorso! Alcançou 20000 de score!",pname);
	case 25000:      format(scstring, sizeof(scstring), "[INFO]: %s agora é mais respeitado! Alcançou 25000 de score!",pname);
	case 30000:      format(scstring, sizeof(scstring), "[INFO]: %s não está de brincadeira! Alcançou 30000 de score!",pname);
	case 35000:      format(scstring, sizeof(scstring), "[INFO]: %s está entre os melhores! Alcançou 35000 de score!",pname);
	case 40000:      format(scstring, sizeof(scstring), "[INFO]: %s continua matando muito! Alcançou 40000 de score!",pname);
	case 45000:      format(scstring, sizeof(scstring), "[INFO]: %s não pensa em se aposentar! Alcançou 45000 de score!",pname);
	case 50000:      format(scstring, sizeof(scstring), "[INFO]: MARCA HISTÓRICA: %s continua matando muito! Alcançou 50000 de score!",pname);
	case 55000:      format(scstring, sizeof(scstring), "[INFO]: %s conseguiu algo inédito! Alcançou 55000 de score!",pname);
	case 60000:      format(scstring, sizeof(scstring), "[INFO]: %s ainda não parou de matar! Alcançou 60000 de score!",pname);
	}

if(strlen(scstring)>10) SendClientMessageToAll(COLOUR_INFORMACAO, scstring);
return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
    if(issuerid != INVALID_PLAYER_ID)
    {
    new string[20];
    format(string, sizeof(string), "~s~-~r~%.0f", amount);
    GameTextForPlayer(playerid, string, 1000, 6);
    GameTextForPlayer(issuerid , string, 1000, 5);
    PlayerPlaySound(issuerid , 17802, 0.0, 0.0, 0.0);
//===============================

	//SNIPER SNP2 ONE SHOT
    if(SNP2[playerid] == true && Arena[playerid] == 1 && GetPlayerWeapon(issuerid) == 34) SetPlayerHealth(playerid,0.0);
    if(X1sArena[playerid] == true && ArenaTipo[playerid] == 100 && GetPlayerWeapon(issuerid) == 34) SetPlayerHealth(playerid,0.0);

	//Evento Sem Danos
	if(NoEvento[playerid] == 1)if(EventoAtivo == 1 && NoEvento[issuerid] == 1 && EventoSemDanos == true) SetPlayerHealth(issuerid,0.0);

	//EventoOHK
	if(NoEvento[playerid] == 1)if(EventoAtivo == 1 && NoEvento[issuerid] == 1 && EventoOHK == true && GetPlayerWeapon(issuerid) > 1) SetPlayerHealth(playerid,0.0);

	DamageTick[playerid] = TickCounter;
    }
	//HS EM ARENA PLAYERS X CARROS
	/*if(issuerid != INVALID_PLAYER_ID && weaponid == 34 && bodypart == 9 && ArenaTipo[playerid] == 69 && mortohs[playerid] == false){
  		new strm[100], matador[MAX_PLAYER_NAME], matado[MAX_PLAYER_NAME];
		GetPlayerName(issuerid,matador,sizeof(matador));
		GetPlayerName(playerid,matado,sizeof(matado));
		if(PVC_Team[issuerid] != PVC_Team[playerid]){
			SetPlayerHealth(playerid, 0.0);
			format(strm,sizeof(strm),"{09FF00}HeadShot: {FF0000}%s {09FF00}deu um HeadShot em {FF0000}%s",matador,matado);
			SendClientMessageToAll(-1,strm);
		  	mortohs[playerid] = true;
		}
	}*/
  	 if(issuerid != INVALID_PLAYER_ID && weaponid == 34 && bodypart == 9 && Arena2[playerid] == 0 && Arena[playerid] == 0 && mortohs[playerid] == false){
		  SetPlayerHealth(playerid, 0.0);
		  new strm[100], matador[MAX_PLAYER_NAME], matado[MAX_PLAYER_NAME];
		  GetPlayerName(issuerid,matador,sizeof(matador));
		  GetPlayerName(playerid,matado,sizeof(matado));
		  format(strm,sizeof(strm),"{09FF00}HeadShot: {FF0000}%s {09FF00}deu um HeadShot em {FF0000}%s",matador,matado);
		  SendClientMessageToAll(-1,strm);
		  mortohs[playerid] = true;
	}

return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
if(Arena[playerid]==1 &&  ArenaTipo[playerid]==69 && PVC_EmProgresso == 1){
	if(PVC_Team[playerid] == 1){
		PVC_Morte_2++;
	}else{
		PVC_Morte_1++;
	}
	if(PVC_TeamBkp[playerid] == 1 && PVC_TeamA[playerid]==true){
        PVC_Morte_B++;
	}
	if(PVC_TeamBkp[playerid] == 2 && PVC_TeamB[playerid] == true){
        PVC_Morte_A++;
	}
}
Duel[playerid] = 998;
X1sArena[playerid] = false;

/*
if(PL_PlayerCD[playerid] == 1 && PL_EmProgresso == 1 && PL_Vai[playerid] == 1){
	for(new i; i < GetMaxPlayers(); i++){
		if(IsPlayerConnected(i)){
		    if(PL_Vai[playerid] == 1){
				SetPlayerCheckpoint(i, 1230.7142,-807.6754,1084.0078 , 1.0);
				PL_Final = 0;
				PL_Dominado = 0;
				PL_DominadoEntregar = false;
			}
		}
	}
}*/

//PREMIO POR MATAR PLAYER DO EOM
if(EAM_Checkpoint[playerid] == true && EAM_EmProgresso == 1){
	if(EAM_Tipo == 0 && PL_Vai[playerid] == 0){
		if(killerid != INVALID_PLAYER_ID && (reason >= 0 && reason <=42)){
		    new quantPlayersOns;
			new string[300];
			new killer_name[MAX_PLAYER_NAME];
			new playerid_name[MAX_PLAYER_NAME];
			GetPlayerName(killerid, killer_name, MAX_PLAYER_NAME);
			GetPlayerName(playerid, playerid_name, MAX_PLAYER_NAME);

            for(new i; i < GetMaxPlayers(); i++){
				if(IsPlayerConnected(i)){
					quantPlayersOns++;
				}
			}
			quantPlayersOns = 20000*quantPlayersOns;
			EAM_EmProgresso = 0;
			EAM_PlayerMorto = true;
			format(string, sizeof(string), "[EAM]: (%s) O player {FFFFFF}%s {FF5A00}chegou e matou {FFFFFF}%s {FF5A00}ganhando o SUPER PREMIO!",EAM_Tipo_STR,killer_name, playerid_name);
			SendClientMessageToAll(COLOUR_EVENTO, string);
			format(string, sizeof(string), "[EAM]: Aguarde que em breve acontecerá outro evento aleatório. Boa sorte!");
			SendClientMessageToAll(COLOUR_EVENTO, string);
			format(string, sizeof(string), "[EAM]: Voce ganhou R$%i por matar o player com o GRANDE PREMIO! Parabens!!", quantPlayersOns);
			SendClientMessage(killerid, COLOUR_INFORMACAO, string);
			format(string, sizeof(string), "[EAM]: Voce nao ganhou nada pois morreu! Boa sorte na proxima!!");
			EventoProibirTeleEAM[playerid] = false;
			SendClientMessage(playerid, COLOUR_INFORMACAO, string);
			CallRemoteFunction("GivePlayerCash", "ii", killerid, quantPlayersOns);
		}else{
			new playerid_name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playerid_name, MAX_PLAYER_NAME);
			EAM_EmProgresso = 0;
			new string[300];
			EAM_PlayerMorto = true;
			format(string, sizeof(string), "[EAM]: O player {FFFFFF}%s {FF5A00}se matou, premio cancelado!",playerid_name);
			SendClientMessageToAll(COLOUR_EVENTO, string);
			format(string, sizeof(string), "[EAM]: Aguarde que em breve acontecerá outro evento aleatório. Boa sorte!");
			SendClientMessageToAll(COLOUR_EVENTO, string);
			format(string, sizeof(string), "[EAM]: Na proxima vez não se mate, tente ficar vivo!!");
			SendClientMessage(playerid, COLOUR_INFORMACAO, string);
			EventoProibirTeleEAM[playerid] = false;
		}
	}
}

if(arenacacadaEsconder[playerid]==1){
	SetPlayerColor(playerid, CorCacada[playerid]);
	NickEsconder[playerid]=0;
	arenacacadaEsconder[playerid]=0;
	ArenacOns--;
}

//XENON
if(Xenon[playerid] == 1){
		if(XenonVerifica[playerid] == 0){
				DestroyObject(Xenons[playerid][0]);
				DestroyObject(Xenons[playerid][1]);
				XenonContagem--;
				XenonContagem--;
		}
		if(XenonVerifica[playerid] == 1){
				DestroyObject(Xenons[playerid][2]);
				DestroyObject(Xenons[playerid][3]);
				XenonContagem--;
				XenonContagem--;
		}
		if(XenonVerifica[playerid] == 2){
				DestroyObject(Xenons[playerid][4]);
				DestroyObject(Xenons[playerid][5]);
				XenonContagem--;
				XenonContagem--;
		}
		if(XenonVerifica[playerid] == 3){
				DestroyObject(Xenons[playerid][6]);
				DestroyObject(Xenons[playerid][7]);
				XenonContagem--;
				XenonContagem--;
		}
		if(XenonVerifica[playerid] == 4){
				DestroyObject(Xenons[playerid][8]);
				DestroyObject(Xenons[playerid][9]);
				DestroyObject(Xenons[playerid][10]);
				DestroyObject(Xenons[playerid][11]);
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
		}
  		if(XenonVerifica[playerid] == 5){
				DestroyObject(Xenons[playerid][12]);
				DestroyObject(Xenons[playerid][13]);
				DestroyObject(Xenons[playerid][14]);
				DestroyObject(Xenons[playerid][15]);
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
		}
		if(XenonVerifica[playerid] == 6){
				DestroyObject(Xenons[playerid][16]);
				DestroyObject(Xenons[playerid][17]);
				DestroyObject(Xenons[playerid][18]);
				DestroyObject(Xenons[playerid][19]);
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
				XenonContagem--;
		}
	Xenon[playerid]=0;
}

noTotForest[playerid] = 0;
    for(new i = 0; i < MAX_PLAYERS; i++){
        if(IsPlayerConnected(i)){
            ShowPlayerNameTagForPlayer(playerid, i, true);
		}
	}

StopFly(playerid);
ccolete[playerid] = 0;
vida[playerid] = 0;
SetPVarInt(playerid,"InMaze",0);
//============================================================================================================================================
//	AntiFakeKill
//============================================================================================================================================
if(killerid != INVALID_PLAYER_ID)
{
	if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2)
	{
		if(playerid == killerid)
		{
		new dbg15[100],pname[30];
		GetPlayerName(playerid, pname, sizeof(pname));
		format(dbg15, sizeof(dbg15), "[ADM]: Possível Fake-Kill próprio de: %s (%i) - O player foi kickado automaticamente",playerid,pname);
		CallRemoteFunction("MessageToAdmins","is",COLOUR_AVISO,dbg15);
		Kick(playerid);
		}

		if(TickCounter - LastDeathTick[playerid] < 1)
		{
		new dbg15[100],pname[30];
		GetPlayerName(playerid, pname, sizeof(pname));
		format(dbg15, sizeof(dbg15), "[ADM]: Possível Fake-Kill múltiplo de: %s (%i) - O player foi kickado automaticamente",playerid,pname);
		CallRemoteFunction("MessageToAdmins","is",COLOUR_AVISO,dbg15);
		Kick(playerid);
		return 0;
		}

	LastDeathTick[playerid] = TickCounter;
	}
}
//============================================================================================================================================


TextDrawHideForPlayer(playerid, Textdraw10);
TextDrawHideForPlayer(playerid, Textdraw8);
TextDrawHideForPlayer(playerid, Textdraw3);

VPlayerMissao[playerid] = 0;

//LOADER
KillTimer(TeleLockTimer[playerid]);

//RESETAR ARMAS POR SEGURANÇA
ResetPlayerWeapons(playerid);

TextDrawHideForPlayer(playerid,Status[playerid]);
TextDrawHideForPlayer(playerid, Textdraw1);
TextDrawHideForPlayer(playerid, Textdraw3);
TextDrawHideForPlayer(playerid, TxDNotificador);
new str_rec[128];
new str_ganhou[128];
new killer_name[MAX_PLAYER_NAME];
new playerid_name[MAX_PLAYER_NAME];
GetPlayerName(killerid, killer_name, MAX_PLAYER_NAME);
GetPlayerName(playerid, playerid_name, MAX_PLAYER_NAME);
if(killerid == INVALID_PLAYER_ID) {
//SUICIDIDO

//ANTI-ABUSO
SendDeathMessage(INVALID_PLAYER_ID,playerid,reason);
SendoAbusado[playerid] = 0;
LastKillerID[playerid] = INVALID_PLAYER_ID;

} else {

//ANTI-ABUSO
NewKillerID[playerid] = killerid;
if(NewKillerID[playerid] == LastKillerID[playerid] && ConnectedPlayers() > 4 && LastKillerID[playerid] != INVALID_PLAYER_ID && Arena[playerid] != 0){
SendoAbusado[playerid]++;
if(SendoAbusado[playerid] > 6){
SendoAbusado[playerid] = 0;
new LogString[150];
format(LogString, sizeof(LogString), "[ADM]: Possível abuso de score de %s (%i) [Matando: %s (%i)] [7x Kill+]", killer_name, killerid, playerid_name, playerid);
CallRemoteFunction("SaveToFile","ss","AbusosScore",LogString);
CallRemoteFunction("MessageToAdmins","is",COLOUR_AVISO,LogString);
}}else{SendoAbusado[playerid] = 0;}
LastKillerID[playerid] = killerid;

//QUADRO DE MORTES
SendDeathMessage(killerid,playerid,reason); // QUADRO DE MORTE

//PLAYERID MATOU ALGUEM - $1000
if (ArenaTipo[killerid] != 4 && ArenaTipo[killerid] != 5){
SetPlayerScore(killerid,GetPlayerScore(killerid)+1); //+1 DE SCORE
ScoreNaSessao[killerid]++;

//Mensagens
CheckAndShowScoreMarks(killerid);

CallRemoteFunction("GivePlayerCash", "ii", killerid, 1000); // DINHEIRO
}else{SendClientMessage(killerid, COLOUR_AVISO, "[ARENA]: As mortes nesta arena não serão contabilizadas como score.");}

//SPREE DAS ARENAS
if(Arena[killerid] == 1){ArenaKills[killerid]++;}

//ARENA A/D
if(AAD_Team[killerid] == 1 && AAD_EmProgresso == 1 && AAD_Vai[killerid] == 1){AAD_Kills_1++;AAD_KillsPerPlayer[killerid]++;}
if(AAD_Team[killerid] == 2 && AAD_EmProgresso == 1 && AAD_Vai[killerid] == 1){AAD_Kills_2++;AAD_KillsPerPlayer[killerid]++;}

if(PVC_Team[killerid] == 1 && PVC_EmProgresso == 1 && PVC_Vai[killerid] == 1){PVC_Kills_1++;PVC_KillsPerPlayer[killerid]++;}
if(PVC_Team[killerid] == 2 && PVC_EmProgresso == 1 && PVC_Vai[killerid] == 1){PVC_Kills_2++;PVC_KillsPerPlayer[killerid]++;}

if(PL_Team[killerid] == 1 && PL_EmProgresso == 1 && PL_Vai[killerid] == 1){PL_Kills_1++;PL_KillsPerPlayer[killerid]++;}
if(PL_Team[killerid] == 2 && PL_EmProgresso == 1 && PL_Vai[killerid] == 1){PL_Kills_2++;PL_KillsPerPlayer[killerid]++;}

// PREMIO POR GANHAR ARENA
if(Arena[playerid] == 1){if(ArenaTipo[playerid] == 1 || ArenaTipo[playerid] == 4 || ArenaTipo[playerid] == 5){
new ssss1[150];
format(ssss1, sizeof(ssss1), "{00FF00}[ARENA DM]: {FFFFFF}%s {00FF00}derrotou {FFFFFF}%s", killer_name, playerid_name);
SetPlayerHealth(killerid, 100);
SetPlayerArmour(killerid, 100);
GameTextForPlayer(playerid,"~r~~n~~n~~n~~n~QUE VERGONHA MORREU!", 3000, 5);
GameTextForPlayer(killerid,"~g~~n~~n~~n~~n~MUITO BOM!", 3000, 5);
if (ArenaTipo[playerid] != 4 && ArenaTipo[playerid] != 5){
SendClientMessageToAll(COLOUR_INFORMACAO, ssss1);
SendClientMessage(killerid, COLOUR_AVISO, "[ARENA]: Parabens você ganhou $3000 mais colete e saúde.");
CallRemoteFunction("GivePlayerCash", "ii", killerid, 3000);}}}

// PREMIO POR GANHAR ARENA CAÇADA
if(Arena[playerid] == 1 && ArenaTipo[playerid] == 24){
	new ssss1[150];
	format(ssss1, sizeof(ssss1), "{00FF00}[ARENA CAÇADA]: {FFFFFF}%s {00FF00}matou {FFFFFF}%s", killer_name, playerid_name);
	SetPlayerHealth(killerid, 100);
	GameTextForPlayer(playerid,"~r~~n~~n~~n~~n~VOCE MORREU!", 3000, 5);
	GameTextForPlayer(killerid,"~g~~n~~n~~n~~n~OTIMO!", 3000, 5);
	SendClientMessageToAll(COLOUR_INFORMACAO, ssss1);
	SendClientMessage(killerid, COLOUR_AVISO, "[ARENA]: Parabens você ganhou $5000 mais vida.");
	CallRemoteFunction("GivePlayerCash", "ii", killerid, 5000);
}

//PREMIO POR GANHAR DUEL
if(DuelArena[playerid] == true || DuelArena[killerid] == true){
	EndDuel(killerid,playerid);
	SendClientMessage(killerid, COLOUR_AVISO, "[DUEL]: Parabens você ganhou $3000.");
	CallRemoteFunction("GivePlayerCash", "ii", killerid, 3000);
}

// PREMIO POR GANHAR COMBATE
if(Arena[playerid] == 1){if(ArenaTipo[playerid] == 6){
new ssss1[150];
format(ssss1, sizeof(ssss1), "{00FF00}[COMBATE]: {FFFFFF}%s {00FF00}aniquilou {FFFFFF}%s", killer_name, playerid_name);
SetPlayerHealth(killerid, 100);
SetPlayerArmour(killerid, 100);
GameTextForPlayer(playerid,"~r~~n~~n~~n~~n~NAO FOI DESTA VEZ!", 3000, 5);
GameTextForPlayer(killerid,"~g~~n~~n~~n~~n~MENOS UM!", 3000, 5);
if (ArenaTipo[playerid] != 4 && ArenaTipo[playerid] != 5){
SendClientMessageToAll(COLOUR_INFORMACAO, ssss1);
SendClientMessage(killerid, COLOUR_AVISO, "[COMBATE]: Parabens você ganhou $3000 mais colete e saúde.");
CallRemoteFunction("GivePlayerCash", "ii", killerid, 3000);}}}

// PREMIO POR GANHAR COMBATE
if(Arena[playerid] == 1){
    if(ArenaTipo[playerid] == 7){
		new ssss1[150];
		format(ssss1, sizeof(ssss1), "{00FF00}[COMBATE SNIPER]: {FFFFFF}%s {00FF00}aniquilou {FFFFFF}%s", killer_name, playerid_name);
		SetPlayerHealth(killerid, 100);
		SetPlayerArmour(killerid, 0);
		GameTextForPlayer(playerid,"~r~~n~~n~~n~~n~NAO FOI DESTA VEZ!", 3000, 5);
		GameTextForPlayer(killerid,"~g~~n~~n~~n~~n~MENOS UM!", 3000, 5);
		if (ArenaTipo[playerid] != 4 && ArenaTipo[playerid] != 5){
			SendClientMessageToAll(COLOUR_INFORMACAO, ssss1);
			SendClientMessage(killerid, COLOUR_AVISO, "[COMBATE SNIPER]: Parabens você ganhou $3000 mais saúde.");
			CallRemoteFunction("GivePlayerCash", "ii", killerid, 3000);
		}
	}
}

if(Arena[playerid] == 1){
	if(ArenaTipo[playerid]==100){
		new ssss1[150];
		format(ssss1, sizeof(ssss1), "{00FF00}[COMBATE X1s]: {FFFFFF}%s {00FF00}matou {FFFFFF}%s", killer_name, playerid_name);
		SetPlayerHealth(killerid, 100);
		SetPlayerArmour(killerid, 0);
		GameTextForPlayer(playerid,"~r~~n~~n~~n~~n~NAO FOI DESTA VEZ!", 3000, 5);
		GameTextForPlayer(killerid,"~g~~n~~n~~n~~n~MENOS UM!", 3000, 5);
		if (ArenaTipo[playerid] != 4 && ArenaTipo[playerid] != 5){
			SendClientMessageToAll(COLOUR_INFORMACAO, ssss1);
			SendClientMessage(killerid, COLOUR_AVISO, "[COMBATE X1s]: Parabens você ganhou $3000 mais saúde.");
			CallRemoteFunction("GivePlayerCash", "ii", killerid, 3000);
		}
	}
}

// PREMIO POR GANHAR ARENA (PORRADA)
if(Arena[playerid] == 1){if(ArenaTipo[playerid] == 2){
new ssss1[150];
format(ssss1, sizeof(ssss1), "{00FF00}[ARENA DM]: {FFFFFF}%s {00FF00}derrotou {FFFFFF}%s", killer_name, playerid_name);
SendClientMessageToAll(COLOUR_INFORMACAO, ssss1);
GameTextForPlayer(playerid,"~r~~n~~n~~n~~n~QUE VERGONHA MORREU!", 3000, 5);
GameTextForPlayer(killerid,"~g~~n~~n~~n~~n~MUITO BOM!", 3000, 5);
SetPlayerHealth(killerid, 100);
SetPlayerArmour(killerid, 0);
SendClientMessage(killerid, COLOUR_AVISO, "[ARENA]: Parabens você ganhou $3000 mais saúde.");
CallRemoteFunction("GivePlayerCash", "ii", killerid, 3000);}}

// PREMIO POR GANHAR ARENA X1
if(Arena[playerid] == 1){if(ArenaTipo[playerid] == 3){
new ssss1[200];
	GetPlayerHealth(killerid, VerVida);
    GetPlayerArmour(killerid, VerColete);
    if(VerVida == 100 && VerColete == 100){
        format(ssss1, sizeof(ssss1), "{00FF00}[X1] {FFFFFF}%s {00FF00}derrotou {FFFFFF}%s {00FF00}de {00FF6E}[PERFECT]", killer_name, playerid_name);
        CallRemoteFunction("SaveToFile","ss","X1",ssss1);
		SendClientMessageToAll(COLOUR_INFORMACAO, ssss1);
	}else{
        format(ssss1, sizeof(ssss1), "{00FF00}[X1] {FFFFFF}%s {00FF00}derrotou {FFFFFF}%s {00FF00}restando {00FF6E}[COLETE: %.0f/ VIDA: %.0f]", killer_name, playerid_name, VerColete, VerVida);
        CallRemoteFunction("SaveToFile","ss","X1",ssss1);
		SendClientMessageToAll(COLOUR_INFORMACAO, ssss1);
	}
GameTextForPlayer(playerid,"~r~~n~~n~~n~~n~QUE VERGONHA MORREU!", 3000, 5);
GameTextForPlayer(killerid,"~g~~n~~n~~n~~n~MUITO BOM!", 3000, 5);
SetPlayerHealth(killerid, 100);
SetPlayerArmour(killerid, 100);
SendClientMessage(killerid, COLOUR_AVISO, "[X1]: Parabens você ganhou $3000!");
CallRemoteFunction("GivePlayerCash", "ii", killerid, 3000);
SetTimerEx("timed_spawn",1000,0, "i", killerid);}}

// PREMIO POR GANHAR ARENA X1 NOVA RUN
if(Arena[playerid] == 1){if(ArenaTipo[playerid] == 13){
new ssss1[200];
	GetPlayerHealth(killerid, VerVida);
    GetPlayerArmour(killerid, VerColete);
    if(VerVida == 100 && VerColete == 100){
        format(ssss1, sizeof(ssss1), "{00FF00}[X1] {FFFFFF}%s {00FF00}derrotou {FFFFFF}%s {00FF00}de {00FF6E}[PERFECT]", killer_name, playerid_name);
        CallRemoteFunction("SaveToFile","ss","X1",ssss1);
		SendClientMessageToAll(COLOUR_INFORMACAO, ssss1);
	}else{
        format(ssss1, sizeof(ssss1), "{00FF00}[X1] {FFFFFF}%s {00FF00}derrotou {FFFFFF}%s {00FF00}restando {00FF6E}[COLETE: %.0f/ VIDA: %.0f]", killer_name, playerid_name, VerColete, VerVida);
        CallRemoteFunction("SaveToFile","ss","X1",ssss1);
		SendClientMessageToAll(COLOUR_INFORMACAO, ssss1);
	}
GameTextForPlayer(playerid,"~r~~n~~n~~n~~n~QUE VERGONHA MORREU!", 3000, 5);
GameTextForPlayer(killerid,"~g~~n~~n~~n~~n~MUITO BOM!", 3000, 5);
SetPlayerHealth(killerid, 100);
SetPlayerArmour(killerid, 100);
SendClientMessage(killerid, COLOUR_AVISO, "[X1]: Parabens você ganhou $3000!");
CallRemoteFunction("GivePlayerCash", "ii", killerid, 3000);
SetTimerEx("timed_spawn",1000,0, "i", killerid);}}

// PREMIO POR GANHAR ARENA X1 NOVA WALK
if(Arena[playerid] == 1){if(ArenaTipo[playerid] == 14){
new ssss1[200];
	GetPlayerHealth(killerid, VerVida);
    GetPlayerArmour(killerid, VerColete);
    if(VerVida == 100 && VerColete == 100){
        format(ssss1, sizeof(ssss1), "{00FF00}[X1 WALK] {FFFFFF}%s {00FF00}derrotou {FFFFFF}%s {00FF00}de {00FF6E}[PERFECT]", killer_name, playerid_name);
        CallRemoteFunction("SaveToFile","ss","X1",ssss1);
		SendClientMessageToAll(COLOUR_INFORMACAO, ssss1);
	}else{
        format(ssss1, sizeof(ssss1), "{00FF00}[X1 WALK] {FFFFFF}%s {00FF00}derrotou {FFFFFF}%s {00FF00}restando {00FF6E}[COLETE: %.0f/ VIDA: %.0f]", killer_name, playerid_name, VerColete, VerVida);
        CallRemoteFunction("SaveToFile","ss","X1",ssss1);
		SendClientMessageToAll(COLOUR_INFORMACAO, ssss1);
	}
GameTextForPlayer(playerid,"~r~~n~~n~~n~~n~QUE VERGONHA MORREU!", 3000, 5);
GameTextForPlayer(killerid,"~g~~n~~n~~n~~n~MUITO BOM!", 3000, 5);
SetPlayerHealth(killerid, 100);
SetPlayerArmour(killerid, 100);
SendClientMessage(killerid, COLOUR_AVISO, "[X1]: Parabens você ganhou $3000!");
CallRemoteFunction("GivePlayerCash", "ii", killerid, 3000);
SetTimerEx("timed_spawn",1000,0, "i", killerid);}}

// PREMIO POR GANHAR ARENA X1 WALK
if(Arena[playerid] == 1){if(ArenaTipo[playerid] == 8){
new ssss1[200];
	GetPlayerHealth(killerid, VerVida);
    GetPlayerArmour(killerid, VerColete);
    if(VerVida == 100 && VerColete == 100){
        format(ssss1, sizeof(ssss1), "{00FF00}[X1 WALK] {FFFFFF}%s {00FF00}derrotou {FFFFFF}%s {00FF00}de {00FF6E}[PERFECT]", killer_name, playerid_name);
        CallRemoteFunction("SaveToFile","ss","X1",ssss1);
		SendClientMessageToAll(COLOUR_INFORMACAO, ssss1);
	}else{
        format(ssss1, sizeof(ssss1), "{00FF00}[X1 WALK] {FFFFFF}%s {00FF00}derrotou {FFFFFF}%s {00FF00}restando {00FF6E}[COLETE: %.0f/ VIDA: %.0f]", killer_name, playerid_name, VerColete, VerVida);
        CallRemoteFunction("SaveToFile","ss","X1",ssss1);
		SendClientMessageToAll(COLOUR_INFORMACAO, ssss1);
	}
GameTextForPlayer(playerid,"~r~~n~~n~~n~~n~QUE VERGONHA MORREU!", 3000, 5);
GameTextForPlayer(killerid,"~g~~n~~n~~n~~n~MUITO BOM!", 3000, 5);
SetPlayerHealth(killerid, 100);
SetPlayerArmour(killerid, 100);
SendClientMessage(killerid, COLOUR_AVISO, "[X1]: Parabens você ganhou $3000!");
CallRemoteFunction("GivePlayerCash", "ii", killerid, 3000);
SetTimerEx("timed_spawn",1000,0, "i", killerid);
}}

//EventoRecarregarLife
if(NoEvento[killerid] == 1)
{
	if(EventoAtivo == 1 && NoEvento[playerid] == 1 && EventoRecarregarLife == true)
	{
	SetPlayerHealth(killerid,100.0);
	if(EventoDarColete == 1) SetPlayerArmour(killerid,100.0);
	}
}


// BONUS DE KILL DE ARMA
if(Arena[killerid] == 0 && DuelArena[killerid] == false){
if(reason == 42){SendClientMessage(killerid, COLOUR_INFORMACAO, "[[[ BÔNUS POR MATAR NO EXTINTOR: $250 ]]]");CallRemoteFunction("GivePlayerCash", "ii", killerid, 250);}
if(reason == 41){SendClientMessage(killerid, COLOUR_INFORMACAO, "[[[ BÔNUS POR MATAR NO SPRAY: $500 ]]]");CallRemoteFunction("GivePlayerCash", "ii", killerid, 500);}
if(reason == 9){SendClientMessage(killerid, COLOUR_INFORMACAO, "[[[ BÔNUS POR MATAR NA MOTOSSERRA: $750 ]]]");CallRemoteFunction("GivePlayerCash", "ii", killerid, 750);}
if(reason == 24){SendClientMessage(killerid, COLOUR_INFORMACAO, "[[[ BÔNUS POR MATAR NA DESERT EAGLE: $1000 ]]]");CallRemoteFunction("GivePlayerCash", "ii", killerid, 1000);}
if(reason == 23){SendClientMessage(killerid, COLOUR_INFORMACAO, "[[[ BÔNUS POR MATAR NA PISTOLA: $1250 ]]]");CallRemoteFunction("GivePlayerCash", "ii", killerid, 1250);}
if(reason == 22){SendClientMessage(killerid, COLOUR_INFORMACAO, "[[[ BÔNUS POR MATAR NAS PISTOLAS: $1500 ]]]");CallRemoteFunction("GivePlayerCash", "ii", killerid, 1500);}
if(reason == 34){SendClientMessage(killerid, COLOUR_INFORMACAO, "[[[ BÔNUS POR MATAR NO SNIPER RIFLE: $1750 ]]]");CallRemoteFunction("GivePlayerCash", "ii", killerid, 1750);}
if(reason == 33){SendClientMessage(killerid, COLOUR_INFORMACAO, "[[[ BÔNUS POR MATAR NO RIFLE: $2000 ]]]");CallRemoteFunction("GivePlayerCash", "ii", killerid, 2000);}
if(reason == 1){SendClientMessage(killerid, COLOUR_INFORMACAO, "[[[ BÔNUS POR MATAR NO SOCO INGLES: $2250 ]]]");CallRemoteFunction("GivePlayerCash", "ii", killerid, 2250);}
if(reason == 0){SendClientMessage(killerid, COLOUR_INFORMACAO, "[[[ BÔNUS POR MATAR NA PORRADA: $2500 ]]]");CallRemoteFunction("GivePlayerCash", "ii", killerid, 2500);}}

/*//CAMERA
if(Arena[playerid]==0 && Arena[killerid]==0 && reason > 0){
	if(IsPlayerSpawned(killerid)){
		new Float:hp, Float:ar;
		new string[200];
		GetPlayerName(killerid,string,sizeof(string));
		GetPlayerHealth(killerid, hp);	GetPlayerArmour(killerid, ar);
		format(string,sizeof(string),"~n~~n~~n~~n~~n~~n~~r~] %s ]- id:%d~n~~w~hp:%0.1f ar:%0.1f ~n~$%d", string,killerid,hp,ar,CallRemoteFunction("GetPlayerCash", "i", killerid));
		GameTextForPlayer(playerid,string,2000,30);
		IniciarAssistir(playerid, killerid);
		KillTimer(AssistirTimer[playerid]);
		Assistindo[playerid] = true;
		AssistirTimer[playerid] = SetTimer("PararAssistir", TempoAssistirMorto, 0);
	}
}else{
	TextDrawShowForPlayer(playerid, Textdraw25);
	TextDrawShowForPlayer(playerid, Textdraw26);
	Assistindo[playerid] = false;
	KillTimer(AssistirTimer[playerid]);
}*/

TextDrawShowForPlayer(playerid, Textdraw25);
TextDrawShowForPlayer(playerid, Textdraw26);
	
//Killspree arena messages
if(Arena[killerid] == 1 && ArenaTipo[killerid] != 3 && ArenaTipo[killerid] != 8){
ProcessarArenaKillSpree(playerid,killerid);}

// CHECAR SE PLAYER ESTA NO VEICULO
if(GetPlayerState(killerid) == PLAYER_STATE_DRIVER){

//ANTI HELI-KILL
if(reason == 50 && Arena[killerid] == 0) {
switch(GetVehicleModel( GetPlayerVehicleID(killerid) )) {
case 548,425,417,487,488,497,563,447,469,465,501:{
HeliKills[killerid]++;
switch(HeliKills[killerid]){
case 1: GameTextForPlayer(killerid,"~r~AVISO ~n~~n~~y~NA PROXIMA~n~VOCE SERA PRESO",5000,3);}
if(HeliKills[killerid] > 1){
new assss5[128];
format(assss5, sizeof(assss5), "%s foi preso por matar com a hélice do helicóptero.", killer_name);
CallRemoteFunction("LJail","ii",killerid,300000);
SendClientMessageToAll(COLOUR_AVISO, assss5);
SendClientMessage(killerid, COLOUR_BRANCO, "É PROIBIDO MATAR NA HÉLICE. VOCÊ FOI PUNIDO POR ISSO. (5 minutos)");}}}}

//ANTI-DB
if(IsPlayerInAnyVehicle(killerid)) {
	if(Arena[playerid]!=1 && ArenaTipo[playerid]!=69 && PVC_Vai[playerid] == 0){
		switch(GetVehicleModel( GetPlayerVehicleID(killerid))){
			case 425,432,447,464,465,476,501,564:return false;
			default: {
				new assss5[128];
				format(assss5, sizeof(assss5), "[ANTI-DB]:{FF0000} O Jogador {FFFFFF}%s {FF0000} foi preso por 2 Minutos {FFFFFF}[Motivo: Noob de DB]", killer_name);
				CallRemoteFunction("GivePlayerCash", "ii", killerid, -8500);
				ScoreNaSessao[killerid]--;
				CallRemoteFunction("LJail","ii",killerid,120000);
				SendClientMessageToAll(-1, assss5);
				SendClientMessage(killerid, COLOUR_ERRO, "{FFC400}VOCÊ FOI PRESO POR MATAR USANDO VEICULO");
				SendClientMessage(killerid, COLOUR_AVISO, "{FFC400}ALÉM DE SER PRESO,PERDEU R$ 8500");
				SendClientMessage(killerid, COLOUR_AVISO, "{FFC400}[TEMPO DE PRISÃO]: 2 Minutos");
				SendClientMessage(killerid, COLOUR_ERRO, "{FFC400}Se continuar fazendo DB poderá ser Kickado ou Banido");
			}
  		}
	}
	}
}

//DAR RECOMPENSA
if(Arena[playerid] == 0){if(GetPlayerState(killerid) == PLAYER_STATE_ONFOOT){
if(GetPlayerWantedLevel(playerid) == 1){format(str_ganhou, sizeof(str_ganhou), "%s ganhou a recompensa de $10000 por matar %s", killer_name, playerid_name);SendClientMessageToAll(COLOUR_INFORMACAO, str_ganhou);CallRemoteFunction("GivePlayerCash", "ii", killerid, 10000);}
if(GetPlayerWantedLevel(playerid) == 2){format(str_ganhou, sizeof(str_ganhou), "%s ganhou a recompensa de $20000 por matar %s", killer_name, playerid_name);SendClientMessageToAll(COLOUR_INFORMACAO, str_ganhou);CallRemoteFunction("GivePlayerCash", "ii", killerid, 20000);}
if(GetPlayerWantedLevel(playerid) == 3){format(str_ganhou, sizeof(str_ganhou), "%s ganhou a recompensa de $30000 por matar %s", killer_name, playerid_name);SendClientMessageToAll(COLOUR_INFORMACAO, str_ganhou);CallRemoteFunction("GivePlayerCash", "ii", killerid, 30000);}
if(GetPlayerWantedLevel(playerid) == 4){format(str_ganhou, sizeof(str_ganhou), "%s ganhou a recompensa de $40000 por matar %s", killer_name, playerid_name);SendClientMessageToAll(COLOUR_INFORMACAO, str_ganhou);CallRemoteFunction("GivePlayerCash", "ii", killerid, 40000);}
if(GetPlayerWantedLevel(playerid) == 5){format(str_ganhou, sizeof(str_ganhou), "%s ganhou a recompensa de $50000 por matar %s", killer_name, playerid_name);SendClientMessageToAll(COLOUR_INFORMACAO, str_ganhou);CallRemoteFunction("GivePlayerCash", "ii", killerid, 50000);}
if(GetPlayerWantedLevel(playerid) == 6){format(str_ganhou, sizeof(str_ganhou), "%s ganhou a recompensa de $60000 por matar %s", killer_name, playerid_name);SendClientMessageToAll(COLOUR_INFORMACAO, str_ganhou);CallRemoteFunction("GivePlayerCash", "ii", killerid, 60000);}}}

// ATUALIZAR CONTADOR DE KILLSPREE
if(GetPlayerState(killerid) == PLAYER_STATE_ONFOOT){
if(Arena[killerid] == 0){
Spree[killerid] = Spree[killerid]+1;
Spree[playerid] = 0;
SetPlayerWantedLevel(playerid, 0);}

// MENSAGEM DE RECOMPENSA $10000
if(Arena[killerid] == 0){if(Spree[killerid] == 10){
format(str_rec, sizeof(str_rec), "PROCURADO: %s (Recompensa: $10000)", killer_name);SendClientMessageToAll(COLOUR_ERRO, str_rec);
SetPlayerWantedLevel(killerid, 1);}

// MENSAGEM DE RECOMPENSA $20000
if(Spree[killerid] == 20){
format(str_rec, sizeof(str_rec), "PROCURADO: %s (Recompensa: $20000)", killer_name);SendClientMessageToAll(COLOUR_ERRO, str_rec);
SetPlayerWantedLevel(killerid, 2);}

// MENSAGEM DE RECOMPENSA $30000
if(Spree[killerid] == 30){
format(str_rec, sizeof(str_rec), "PROCURADO: %s (Recompensa: $30000)", killer_name);SendClientMessageToAll(COLOUR_ERRO, str_rec);
SetPlayerWantedLevel(killerid, 3);}

// MENSAGEM DE RECOMPENSA $40000
if(Spree[killerid] == 40){
format(str_rec, sizeof(str_rec), "PROCURADO: %s (Recompensa: $40000)", killer_name);SendClientMessageToAll(COLOUR_ERRO, str_rec);
SetPlayerWantedLevel(killerid, 4);}

// MENSAGEM DE RECOMPENSA $50000
if(Spree[killerid] == 50){
format(str_rec, sizeof(str_rec), "PROCURADO: %s (Recompensa: $50000)", killer_name);SendClientMessageToAll(COLOUR_ERRO, str_rec);
SetPlayerWantedLevel(killerid, 5);}

// MENSAGEM DE RECOMPENSA $60000
if(Spree[killerid] == 60){
format(str_rec, sizeof(str_rec), "PROCURADO: %s (Recompensa: $60000)", killer_name);SendClientMessageToAll(COLOUR_ERRO, str_rec);
SetPlayerWantedLevel(killerid, 6);}}
}

  		}

	 if(ArenaTipo[playerid] == 3){X1 = X1-1;ArenaTipo[playerid] = 0;Arena[playerid] = 0;}
	//Arena[playerid] = 0;
    //ArenaTipo[playerid] = 0;
    //SetPlayerHealth(playerid, 100.0);

    if(Txverifica[playerid] == 0){
		TextDrawHideForPlayer(playerid, Textdraw8);
		TextDrawHideForPlayer(playerid, TxDNotificador);
		TextDrawHideForPlayer(playerid, Textdraw3);
		TextDrawHideForPlayer(playerid, Textdraw10);
		TextDrawHideForPlayer(playerid,Status[playerid]);
	}

 	return 1;
}


//------------------------------------------------------------------------------------------------------


public OnPlayerRequestClass(playerid, classid)
{
GameTextForPlayer(playerid, " ", 100, 5);
TextDrawHideForPlayer(playerid, ImagemEntrada);
TextDrawHideForPlayer(playerid, texto9);
SetupPlayerForClassSelection(playerid);
return 1;
}

public SetupPlayerForClassSelection(playerid)
{
TextDrawHideForPlayer(playerid, Textdraw26);
TextDrawHideForPlayer(playerid, Textdraw25);
new classstatus = CallRemoteFunction("ClassPosition", "i", playerid);
if(classstatus != 1){
//  CLASS
	 SetPlayerInterior(playerid,14);
	 SetPlayerPos(playerid,258.4893,-41.4008,1002.0234);
	 SetPlayerFacingAngle(playerid, 270.0);
	 SetPlayerCameraPos(playerid,256.0815,-43.0475,1004.0234);
	 SetPlayerCameraLookAt(playerid,258.4893,-41.4008,1002.0234);
	 ApplyAnimation(playerid,"DEALER","DEALER_IDLE",4.0,1,0,0,0,0);
}

TextDrawShowForPlayer(playerid, TDEditor_TD[0]);
TextDrawShowForPlayer(playerid, TDEditor_TD[1]);
TextDrawShowForPlayer(playerid, TDEditor_TD[2]);
TextDrawShowForPlayer(playerid, TDEditor_TD[3]);
TextDrawShowForPlayer(playerid, TDEditor_TD[4]);
TextDrawShowForPlayer(playerid, TDEditor_TD[5]);
TextDrawShowForPlayer(playerid, TDEditor_TD[6]);
TextDrawShowForPlayer(playerid, topblack);
TextDrawShowForPlayer(playerid, bottomblack);
TextDrawShowForPlayer(playerid, texto1);
TextDrawHideForPlayer(playerid, texto9);
TextDrawShowForPlayer(playerid, texto8);
//ApplyAnimation(playerid,"DEALER","DEALER_IDLE",4.0,1,0,0,0,0);
}

public GameModeExitFunc()
{
KillTimer(MSGTimer);
KillTimer(timerclock);
GameModeExit();
}



public RandomWeather(){
new rand = random(sizeof(gRandomWeatherIDs));
SetWeather(gRandomWeatherIDs[rand][wt_id]);
dini_IntSet("ZNS.ini","clima",gRandomWeatherIDs[rand][wt_id]);
return 1;}

forward UpdateTxDStatus(playerid);

public UpdateTxDStatus(playerid)
{

new string[500];
new str[128];
	format(str, sizeof(str), "LAGANGS/Players/%s.ini", Nome(playerid));
	PlayerDados[playerid][Membro] = DOF2_GetInt(str, "Membro");

	if(Arena[playerid] == 1 && ArenaTipo[playerid] == 69){
	    if(PVC_Carro == true && PVC_Moto == false && PVC_NomeTime[playerid] == 1){
		    format(string,sizeof(string),"~w~] ~r~~h~~h~TIME A~n~~w~] ~r~~h~~h~PLAYERS: ~w~%i~N~~w~] ~r~~h~~h~CARROS: ~w~%i~n~~w~] ~r~~h~~h~RODADA: ~w~%i" , PVC_Morte_1, PVC_Morte_2, PVC_Round);
			TextDrawSetString(Status[playerid],string);
		}
		if(PVC_Carro == true && PVC_Moto == false && PVC_NomeTime[playerid] == 2){
		    format(string,sizeof(string),"~w~] ~r~~h~~h~TIME B~n~~w~] ~r~~h~~h~PLAYERS: ~w~%i~N~~w~] ~r~~h~~h~CARROS: ~w~%i~n~~w~] ~r~~h~~h~RODADA: ~w~%i" , PVC_Morte_1, PVC_Morte_2, PVC_Round);
			TextDrawSetString(Status[playerid],string);
		}
		if(PVC_Moto == true && PVC_Carro == false && PVC_NomeTime[playerid] == 1){
			format(string,sizeof(string),"~w~] ~r~~h~~h~TIME A~n~~w~] ~r~~h~~h~PLAYERS: ~w~%i~N~~w~] ~r~~h~~h~MOTOS: ~w~%i~n~~w~] ~r~~h~~h~RODADA: ~w~%i" , PVC_Morte_1, PVC_Morte_2, PVC_Round);
			TextDrawSetString(Status[playerid],string);
		}
		if(PVC_Moto == true && PVC_Carro == false && PVC_NomeTime[playerid] == 2){
			format(string,sizeof(string),"~w~] ~r~~h~~h~TIME B~n~~w~] ~r~~h~~h~PLAYERS: ~w~%i~N~~w~] ~r~~h~~h~MOTOS: ~w~%i~n~~w~] ~r~~h~~h~RODADA: ~w~%i" , PVC_Morte_1, PVC_Morte_2, PVC_Round);
			TextDrawSetString(Status[playerid],string);
		}
	}else if(Arena[playerid] == 1 && ArenaTipo[playerid] == 26){
		format(string,sizeof(string),"~w~] ~r~~h~~h~POLICIA: ~w~%i~N~~w~] ~r~~h~~h~LADRAO: ~w~%i" , (PL_Kills_1), (PL_Kills_2));
		TextDrawSetString(Status[playerid],string);
	}else if((Arena[playerid] == 1 || Arena2[playerid] == 1 || MostrandoFPSPing[playerid] == true) && PlayerDados[playerid][Membro] == 0){
		format(string,sizeof(string),"~R~~h~PING: ~w~%i~N~~R~~h~FPS: ~w~%i",GetPlayerPing(playerid),GetPlayerFPS(playerid));
		TextDrawSetString(Status[playerid],string);
	}else if((Arena[playerid] == 0 || Arena2[playerid] == 0 || MostrandoFPSPing[playerid] == true) && PlayerDados[playerid][Membro] == 0){
		format(string,sizeof(string),"~w~] ~r~~h~~h~SCORE: ~w~%i~N~~w~] ~r~~h~~h~SPREE: ~w~%i~N~~w~] ~r~~h~~h~PING: ~w~%i~N~~w~] ~r~~h~~h~FPS: ~w~%i",GetPlayerScore(playerid),Spree[playerid],GetPlayerPing(playerid),GetPlayerFPS(playerid));
        TextDrawSetString(Status[playerid],string);
	}else if((Arena[playerid] == 1 || Arena2[playerid] == 1 || MostrandoFPSPing[playerid] == true) && PlayerDados[playerid][Membro]>0){
		format(str, sizeof(str), "LAGANGS/Gangs/%d.ini", GangPlayer(playerid));
		format(string,sizeof(string),"~r~~h~~h~CLA: %s~n~~r~~h~PING: ~w~%i~n~~R~~h~FPS: ~w~%i",DOF2_GetString(str, "Nome"), GetPlayerPing(playerid),GetPlayerFPS(playerid));
		TextDrawSetString(Status[playerid],string);
	}else if((Arena[playerid] == 0 || Arena2[playerid] == 0 || MostrandoFPSPing[playerid] == true) && PlayerDados[playerid][Membro]>0){
	    format(str, sizeof(str), "LAGANGS/Gangs/%d.ini", GangPlayer(playerid));
		format(string,sizeof(string),"~w~] ~r~~h~~h~CLA: %s~n~~w~] ~r~~h~~h~SCORE: ~w~%i~N~~w~] ~r~~h~~h~SPREE: ~w~%i~N~] ~r~~h~~h~PING: ~w~%i~N~] ~r~~h~~h~FPS: ~w~%i",DOF2_GetString(str, "Nome"), GetPlayerScore(playerid),Spree[playerid],GetPlayerPing(playerid),GetPlayerFPS(playerid));
        TextDrawSetString(Status[playerid],string);
	}
return 1;

}

public OnGameModeExit()
{
SaveConfig();
return 1;
}

stock SetGranaFacil(grana)
{
GranaFacilValor = grana;
new GranaFacilString[220];
if(grana > 0)
format(GranaFacilString, sizeof(GranaFacilString), "{00A700}Área da grana fácil!\n\n{FFFFFF}Continue caminhando aqui e \nganhará {00A700}$%i{FFFFFF} por segundo!\n\n{A5A5A5}Só ganha se estiver caminhando!\nSe ficar parado, no carro ou ESC não ganha!", grana);
else
GranaFacilString = " ";
Update3DTextLabelText(GranaFacil3DTXT, 0xFF8408FF, GranaFacilString);
dini_IntSet("ZNS.ini","granafacil",grana);
return 1;
}


public OnGameModeInit()
{
printf("  Carregando gamemode...");
Primeiro3DTXT = Create3DTextLabel("Las Venturas",0xEDED26FF,2034.8655,985.3180,16.5435,50,0,0);
GranaFacil3DTXT = Create3DTextLabel(" ",0xFFFFFFFF,2177.0662,914.4052,10.8203,20,0,0); //GranaFacil
Create3DTextLabel("Ammunation\nArmas grátis!",0xEDED26FF,2158.2080,950.1351,10.9856,50,0,0);
Create3DTextLabel("{00FF00}Bar do {FF4000}MotoXeX\n{CC3361}HP, colete e Jetpack grátis\n {FF00FF}quando está aberto!",0x0083ADFF,-1576.7567,-2732.5681,48.5335,50,0,0);
Create3DTextLabel("{00FF00}Ammunation de Los Santos - Entre",0xEDED26FF,1363.6404,-1279.6017,13.5469,50,0,0);
Create3DTextLabel("{00FF00}Pegue o Seu Aqui seu kit Guerra",0xEDED26FF,296.4969,-32.2718,1001.5156,50,0,0);
Create3DTextLabel("Puteiro dos [MdP]!\nDiversão da sexta-feira!(após as 23:00)",0x0597F2FF,-2627.5825,1401.9584,7.1016,50,0,0);
Create3DTextLabel("As melhores baladas",0x0083ADFF,1834.5376,-1682.5906,13.4274,50,0,0);
Create3DTextLabel("Saída para:\nSan Fierro",0x0083ADFF,1423.9917,863.2894,6.8142,50,0,0);
Create3DTextLabel("Saída para:\nLos Santos",0x0083ADFF,1797.2371,819.7002,11.6232,50,0,0);
Create3DTextLabel("Saída para:\nDeserto",0x0083ADFF,1343.3093,2473.9600,6.8071,50,0,0);
Create3DTextLabel("Saída para:\nDeserto",0x0083ADFF,1240.7540,2190.1631,6.6720,50,0,0);
Create3DTextLabel("Saída para:\nSan Fierro",0x0083ADFF,1202.3481,988.4680,7.0857,50,0,0);
Create3DTextLabel("Ainda tem mais drift e so\ncontinuar descendo!",0x1CD622FF,-295.8597,1538.4200,75.5625,50,0,0);
Create3DTextLabel("Cabana Abandonada",0x015C8DFF,-2810.0352,-1527.0503,140.8438,50,0,0);
Create3DTextLabel("Ferro Velho",0x015C8DFF,-1865.4684,-1661.7889,22.1249,50,0,0);
Create3DTextLabel("Continuaçao da\nPista de Drift",0x1CD622FF,-443.3212,1409.2059,32.5866,70,0,0);
Create3DTextLabel("Para navegar até a ILHA\ndigite {FFFFFF}/navegar",0x1CD622FF,2934.2612,-2054.2427,3.5480,219,0,0);
Create3DTextLabel("Bem vindo a ILHA,\npara voltar {FFFFFF}/nvoltar",0x1CD622FF,4227.0684,-1991.6500,6.2695,255,0,0);
Create3DTextLabel("FIM da Pista de Drift",0xEDED26FF,-446.1817,1490.3044,34.5877,30,0,0);
Create3DTextLabel("Vire a direita para\ncontinuar a Pista de Drift",0xEDED26FF,-711.1558,1291.2307,17.3998,50,0,0);
Create3DTextLabel("Pegue essa rua para ir\naté o Parkour de Quadriciclo",0xFFFFFFFF,797.2311,-1840.7546,11,50,0,0);
Create3DTextLabel("Sugiro pegar um Quadriciclo\nse você nao sabe Pegar /vm quad",0xFFFFFFFF,756.9478,-2564.1528,12.4894,50,0,0);
//BY MOTOXEX EASTER EGG
Create3DTextLabel("KIFFLOM",0x00BFFFFF,204.5965,-261.7506,1.7044,50,0,0);
MensagemADMAtivado = 1;
AntiDeAMX();
AAD_Timer = SetTimer("AAD_DefLobby",AAD_TIME_IntervaloEntrePartidas, 0);
PVC_Timer = SetTimer("PVC_DefLobby",PVC_TIME_IntervaloEntrePartidas, 0);
PL_Timer = SetTimer("PL_DefLobby",PL_TIME_IntervaloEntrePartidas, 0);
EAM_Timer = SetTimer("EAM_DefLobby",EAM_TIME_IntervaloEntrePartidas, 0);
clock(1);
TickCounter = 0;
X1 = 0;
SetTimer("TimerPorSegundo", 997, 1);
SetTimer("InfiniteNitro",10200,1);
SetTimer("Velocimetro",453,1);
SetTimer("TimerRapido",100,1);
timerclock = SetTimer("clock",AtualizarWorldTime,1);
MSGTimer = SetTimer("RandomMSGs",150000,1);
SetGameModeText("Brasil-[MdP]MATA-MATA");
SendRconCommand("mapname BRASIL - San Andreas");
ShowNameTags(1);
AllowInteriorWeapons(0);
UsePlayerPedAnims();
EnableStuntBonusForAll(0);
SetTeamCount(15);
pickupammu = CreatePickup(328, 1, 288.2398,-77.5945,1001.5156, -1);
PickGeral = CreatePickup(362, 8, 287.7219,-106.5689,1001.5156, -1);
PickGeral2 = CreatePickup(362, 8, 297.4139,-33.2752,1001.5156, -1);
PickGeral3 = CreatePickup(362, 8, 308.1394,-167.6732,999.5938, -1);
PickGeral4 = CreatePickup(362, 8, 1797.2728,-1296.8812,120.2656, -1);
PickBHD = CreatePickup(362, 8, 238.9293,-1202.3063,76.1403, -1);

CreatePickup(1240, 1, 1607.2742,1818.1442,10.8203, -1); // HOSPITAL DE VERDADE LV

for(new i; i < GetMaxPlayers(); i++)
{

//Inicializar variáveis dos players
Neon[0][i] = -1;
Neon[1][i] = -1;


//TEXTDRAW VELOCIMETRO
TXTVELOCIDADE[i] = TextDrawCreate(117.000000, 301.000000,"         ");
TextDrawAlignment(TXTVELOCIDADE[i],3);
TextDrawBackgroundColor(TXTVELOCIDADE[i],255);
TextDrawFont(TXTVELOCIDADE[i],2);
TextDrawLetterSize(TXTVELOCIDADE[i],0.400000, 1.600000);
TextDrawColor(TXTVELOCIDADE[i],-16776961);
TextDrawSetProportional(TXTVELOCIDADE[i],1);
TextDrawSetShadow(TXTVELOCIDADE[i],2);
TextDrawSetOutline(TXTVELOCIDADE[i], 1);

//TEXTDRAW STATUS
Status[i] = TextDrawCreate(538.000000, 340.000000, "");//542.000000, 380.000000
TextDrawBackgroundColor(Status[i], 255);
TextDrawFont(Status[i], 2);
TextDrawLetterSize(Status[i], 0.270000, 1.400000);
TextDrawColor(Status[i], 0x0F1FFAFF);
TextDrawSetOutline(Status[i], 1);
TextDrawSetProportional(Status[i], 1);
TextDrawUseBox(Status[i], 1);
TextDrawBoxColor(Status[i], 50);
TextDrawTextSize(Status[i], 629.000000, -60.000000);
}

//TEXTDRAWS DE BOAS VINDAS
TDEditor_TD[0] = TextDrawCreate(10.000006, 349.039916, "~r~~h~MUNDO_DOS_~n~____~r~~h~PIKAS");
TextDrawLetterSize(TDEditor_TD[0], 0.860000, 3.444264);
TextDrawAlignment(TDEditor_TD[0], 1);
TextDrawSetShadow(TDEditor_TD[0], 80);
TextDrawSetOutline(TDEditor_TD[0], 1);
TextDrawBackgroundColor(TDEditor_TD[0], 255);
TextDrawFont(TDEditor_TD[0], 3);
TextDrawSetProportional(TDEditor_TD[0], 1);
TextDrawSetShadow(TDEditor_TD[0], 80);

TDEditor_TD[1] = TextDrawCreate(300.399871, 363.226867, "0.3.7");
TextDrawLetterSize(TDEditor_TD[1], 0.400000, 1.600000);
TextDrawAlignment(TDEditor_TD[1], 1);
TextDrawColor(TDEditor_TD[1], -1);
TextDrawSetShadow(TDEditor_TD[1], 0);
TextDrawSetOutline(TDEditor_TD[1], 1);
TextDrawBackgroundColor(TDEditor_TD[1], 1140850943);
TextDrawFont(TDEditor_TD[1], 2);
TextDrawSetProportional(TDEditor_TD[1], 1);
TextDrawSetShadow(TDEditor_TD[1], 0);

TDEditor_TD[2] = TextDrawCreate(-6.799591, 0.346615, "____~n~~n~");
TextDrawLetterSize(TDEditor_TD[2], 0.400000, 1.600000);
TextDrawTextSize(TDEditor_TD[2], 666.200256, 0.000000);
TextDrawAlignment(TDEditor_TD[2], 1);
TextDrawColor(TDEditor_TD[2], -1);
TextDrawUseBox(TDEditor_TD[2], 1);
TextDrawBoxColor(TDEditor_TD[2], 255);
TextDrawSetShadow(TDEditor_TD[2], 0);
TextDrawSetOutline(TDEditor_TD[2], 0);
TextDrawBackgroundColor(TDEditor_TD[2], 255);
TextDrawFont(TDEditor_TD[2], 2);
TextDrawSetProportional(TDEditor_TD[2], 1);
TextDrawSetShadow(TDEditor_TD[2], 0);

TDEditor_TD[4] = TextDrawCreate(560.399719, 34.693328, "MdP");
TextDrawLetterSize(TDEditor_TD[4], 0.400000, 1.600000);
TextDrawAlignment(TDEditor_TD[4], 1);
TextDrawColor(TDEditor_TD[4], -1);
TextDrawSetShadow(TDEditor_TD[4], 2);
TextDrawSetOutline(TDEditor_TD[4], 0);
TextDrawBackgroundColor(TDEditor_TD[4], 255);
TextDrawFont(TDEditor_TD[4], 2);
TextDrawSetProportional(TDEditor_TD[4], 1);
TextDrawSetShadow(TDEditor_TD[4], 2);

TDEditor_TD[5] = TextDrawCreate(13.200031, 337.093383, "Bem_Vindo");
TextDrawLetterSize(TDEditor_TD[5], 0.459200, 1.712000);
TextDrawAlignment(TDEditor_TD[5], 1);
TextDrawColor(TDEditor_TD[5], -1);
TextDrawSetShadow(TDEditor_TD[5], 0);
TextDrawSetOutline(TDEditor_TD[5], 1);
TextDrawBackgroundColor(TDEditor_TD[5], 255);
TextDrawFont(TDEditor_TD[5], 0);
TextDrawSetProportional(TDEditor_TD[5], 1);
TextDrawSetShadow(TDEditor_TD[5], 0);

TDEditor_TD[6] = TextDrawCreate(-10.790573, 418.750976, "_______~n~~n~~n~");
TextDrawLetterSize(TDEditor_TD[6], 0.400000, 1.600000);
TextDrawTextSize(TDEditor_TD[6], 684.810058, 0.000000);
TextDrawAlignment(TDEditor_TD[6], 1);
TextDrawColor(TDEditor_TD[6], -1);
TextDrawUseBox(TDEditor_TD[6], 1);
TextDrawBoxColor(TDEditor_TD[6], 255);
TextDrawSetShadow(TDEditor_TD[6], 0);
TextDrawSetOutline(TDEditor_TD[6], 0);
TextDrawBackgroundColor(TDEditor_TD[6], 255);
TextDrawFont(TDEditor_TD[6], 2);
TextDrawSetProportional(TDEditor_TD[6], 1);
TextDrawSetShadow(TDEditor_TD[6], 0);

//Textdraw1 = TextDrawCreate(2.000000, 438.000000, "/COMANDOS /REGRAS /REGRAS2 /GERAL /APARENCIA /DINHEIRO /VEICULOS /TELES /MDM /PROPRIEDADES   >>>  BLOODY VEGAS SERVER - DM/4FUN");
//Textdraw1 = TextDrawCreate(2.000000, 438.000000, "/COMANDOS /REGRAS /REGRAS2 /GERAL /APARENCIA /DINHEIRO /VEICULOS /TELES /MDM /PROPRIEDADES   >>>  BLOODY VEGAS SERVER - DM/4FUN");
Textdraw1 = TextDrawCreate(1.000000, 437.000000, "_____________________________________]   MUNDO DOS PIKAS 2017   ]");
TextDrawBackgroundColor(Textdraw1, 255);
TextDrawFont(Textdraw1, 2);
TextDrawLetterSize(Textdraw1, 0.400000, 0.999999);
TextDrawColor(Textdraw1, 0xB33434FF);
TextDrawSetOutline(Textdraw1, 1);
TextDrawSetProportional(Textdraw1, 1);
TextDrawSetShadow(Textdraw1, 1);
TextDrawUseBox(Textdraw1, 1);
TextDrawBoxColor(Textdraw1, 0x00000066);
TextDrawTextSize(Textdraw1, 900.000000, 0.000000);

//RELÓGIO
Textdraw3 = TextDrawCreate(549.000000, 24.000000, " ");
TextDrawBackgroundColor(Textdraw3, 0x000000FF );
TextDrawFont(Textdraw3, 3);
TextDrawLetterSize(Textdraw3, 0.609999, 2.099999);
TextDrawColor(Textdraw3,0xE66C09FF);
TextDrawSetOutline(Textdraw3, 1);
TextDrawSetProportional(Textdraw3, 1);
TextDrawBoxColor(Textdraw1, 0x000000FF);

	//tela de morte
	Textdraw25 = TextDrawCreate(654.000183, 178.459991, "usebox");
	TextDrawLetterSize(Textdraw25, 0.486400, 9.375066);
	TextDrawTextSize(Textdraw25, -226.000030, 0.746666);
	TextDrawAlignment(Textdraw25, 1);
	TextDrawColor(Textdraw25, 0);
	TextDrawUseBox(Textdraw25, true);
	TextDrawBoxColor(Textdraw25, 102);
	TextDrawSetShadow(Textdraw25, 0);
	TextDrawSetOutline(Textdraw25, 0);
	TextDrawFont(Textdraw25, 3);

	Textdraw26 = TextDrawCreate(200.799926, 196.373291, "SE FODEU");
	TextDrawLetterSize(Textdraw26, 1.269999, 5.258665);
	TextDrawAlignment(Textdraw26, 1);
	TextDrawColor(Textdraw26, -16776961);
	TextDrawSetShadow(Textdraw26, 0);
	TextDrawSetOutline(Textdraw26, 3);
	TextDrawBackgroundColor(Textdraw26, 255);
	TextDrawFont(Textdraw26, 3);
	TextDrawSetProportional(Textdraw26, 1);

	//TELA PVC
	Textdraw27 = TextDrawCreate(200.799926, 196.373291, "RODADA 1");
	TextDrawLetterSize(Textdraw27, 1.269999, 5.258665);
	TextDrawAlignment(Textdraw27, 1);
	TextDrawColor(Textdraw27, -16776961);
	TextDrawSetShadow(Textdraw27, 0);
	TextDrawSetOutline(Textdraw27, 3);
	TextDrawBackgroundColor(Textdraw27, 255);
	TextDrawFont(Textdraw27, 3);
	TextDrawSetProportional(Textdraw27, 1);

	Textdraw28 = TextDrawCreate(200.799926, 196.373291, "RODADA 2");
	TextDrawLetterSize(Textdraw28, 1.269999, 5.258665);
	TextDrawAlignment(Textdraw28, 1);
	TextDrawColor(Textdraw28, -16776961);
	TextDrawSetShadow(Textdraw28, 0);
	TextDrawSetOutline(Textdraw28, 3);
	TextDrawBackgroundColor(Textdraw28, 255);
	TextDrawFont(Textdraw28, 3);
	TextDrawSetProportional(Textdraw28, 1);

	Textdraw29 = TextDrawCreate(200.799926, 196.373291, "RODADA 3");
	TextDrawLetterSize(Textdraw29, 1.269999, 5.258665);
	TextDrawAlignment(Textdraw29, 1);
	TextDrawColor(Textdraw29, -16776961);
	TextDrawSetShadow(Textdraw29, 0);
	TextDrawSetOutline(Textdraw29, 3);
	TextDrawBackgroundColor(Textdraw29, 255);
	TextDrawFont(Textdraw29, 3);
	TextDrawSetProportional(Textdraw29, 1);

	Textdraw30 = TextDrawCreate(200.799926, 196.373291, "RODADA 4");
	TextDrawLetterSize(Textdraw30, 1.269999, 5.258665);
	TextDrawAlignment(Textdraw30, 1);
	TextDrawColor(Textdraw30, -16776961);
	TextDrawSetShadow(Textdraw30, 0);
	TextDrawSetOutline(Textdraw30, 3);
	TextDrawBackgroundColor(Textdraw30, 255);
	TextDrawFont(Textdraw30, 3);
	TextDrawSetProportional(Textdraw30, 1);

	//PLAYERS ONLINE
	Textdraw10 = TextDrawCreate(584.000000, 7.000000, " ");
	TextDrawAlignment(Textdraw10, 2);
	TextDrawBackgroundColor(Textdraw10, 0x000000FF);
	TextDrawFont(Textdraw10, 2);
	TextDrawLetterSize(Textdraw10, 0.250000, 1.200000);
	TextDrawColor(Textdraw10, 0xE66C09FF);
	TextDrawSetOutline(Textdraw10, 1);
	TextDrawSetProportional(Textdraw10, 1);

	ImagemEntrada = TextDrawCreate(1.000000, -1.000000, "loadsc12:loadsc12");
	TextDrawBackgroundColor(ImagemEntrada, 255);
	TextDrawFont(ImagemEntrada, 4);
	TextDrawLetterSize(ImagemEntrada, 0.500000, 1.000000);
	TextDrawColor(ImagemEntrada, -1);
	TextDrawSetOutline(ImagemEntrada, 0);
	TextDrawSetProportional(ImagemEntrada, 1);
	TextDrawSetShadow(ImagemEntrada, 1);
	TextDrawUseBox(ImagemEntrada, 1);
	TextDrawBoxColor(ImagemEntrada, 255);
	TextDrawTextSize(ImagemEntrada, 645.000000, 450.000000);

	//TEXTDRAW NOTIFICADOR
	TxDNotificador = TextDrawCreate(135.000000, 410.000000, "   ");
	TextDrawBackgroundColor(TxDNotificador, 255);
	TextDrawFont(TxDNotificador, 1);
	TextDrawLetterSize(TxDNotificador, 0.270000, 1.200000);
	//TextDrawColor(TxDNotificador, 16711935);
	TextDrawSetOutline(TxDNotificador, 1);
	TextDrawSetProportional(TxDNotificador, 1);

	//TEXTDRAW TELA3
	TxDTela3 = TextDrawCreate(325.000000, 354.000000, " ");
	TextDrawAlignment(TxDTela3, 2);
	TextDrawBackgroundColor(TxDTela3, 255);
	TextDrawFont(TxDTela3, 1);
	TextDrawLetterSize(TxDTela3, 0.479999, 2.099999);
	TextDrawColor(TxDTela3, -1);
	TextDrawSetOutline(TxDTela3, 1);
	TextDrawSetProportional(TxDTela3, 1);
	TextDrawHideForAll(TxDTela3);

//AddStaticPickup(1240, 2, 2090.3691,900.4456,19.0792); //VIDA
//AddStaticPickup(1242, 2, 2090.6987,902.6465,19.0792); //COLETE
//AddStaticPickup(370, 2, 2093.3403,908.0361,19.0792); //JETPACK

AddStaticVehicleEx(415,1703.4375,2202.2590,10.5921,2.1171,PVA(),PVA(),60); // STEAKHOUSE
AddStaticVehicleEx(541,1691.8300,2201.9072,10.4410,357.6496,PVA(),PVA(),60); // STEAKHOUSE
AddStaticVehicleEx(402,1685.0874,2202.0691,10.6530,359.0571,PVA(),PVA(),60); // STEAKHOUSE
AddStaticVehicleEx(603,1643.3673,2196.8435,10.6584,358.0955,PVA(),PVA(),60); // LUSADOS
AddStaticVehicleEx(559,1626.5090,2197.2754,10.4779,0.9003,PVA(),PVA(),60); // LUSADOS

AddStaticVehicle(411,1357.5453,-610.2537,108.8610,285.5733,PVA(),PVA()); // MANSAO_ZNS
AddStaticVehicle(411,1358.7404,-614.1187,108.8611,286.4662,PVA(),PVA()); // MANSAO_ZNS
AddStaticVehicle(411,1359.9368,-618.0513,108.8611,284.9959,PVA(),PVA()); // MANSAO_ZNS
AddStaticVehicle(411,1360.9258,-621.6718,108.8611,284.2811,PVA(),PVA()); // MANSAO_ZNS

AddStaticVehicleEx(435,1661.8840,987.1829,11.4551,181.4339,PVA(),PVA(),60); // TRUCK_DEPOT_TRAILER
AddStaticVehicleEx(435,1655.3281,987.1160,11.4553,180.3573,PVA(),PVA(),60); // TRUCK_DEPOT_TRAILER
AddStaticVehicleEx(403,1681.0028,1001.3403,11.4264,0.1955,PVA(),PVA(),60); // TRUCK_DEPOT_CAVALO
AddStaticVehicleEx(403,1674.6752,1001.3871,11.4327,1.1826,PVA(),PVA(),60); // TRUCK_DEPOT_CAVALO

AddStaticVehicleEx(435,2102.9629,2039.6300,11.4538,90.9679,PVA(),PVA(),60); // TRAILER SEXSHOP
AddStaticVehicleEx(403,2102.9368,2072.6650,11.4260,90.1336,PVA(),PVA(),60); // CAVALO SEXSHOP

AddStaticVehicleEx(451,-320.8506,1515.2542,75.0645,179.0520,PVA(),PVA(),60); // DRIFT
AddStaticVehicleEx(603,-330.3677,1515.5072,75.1971,180.5350,PVA(),PVA(),60); // DRIFT
AddStaticVehicleEx(415,-339.9676,1515.0905,75.1305,182.4702,PVA(),PVA(),60); // DRIFT
AddStaticVehicleEx(475,-282.9377,1559.5840,75.1635,134.4263,PVA(),PVA(),60); // DRIFT
AddStaticVehicleEx(411,-274.8638,1552.6509,75.0865,134.3288,PVA(),PVA(),60); // DRIFT

AddStaticVehicleEx(411,-2020.3270,76.8453,27.6910,92.3399,PVA(),PVA(),60); // SF
AddStaticVehicleEx(411,-2020.8738,84.7182,27.6898,93.3307,PVA(),PVA(),60); // SF
AddStaticVehicleEx(411,-2021.0950,92.6018,27.7220,90.9044,PVA(),PVA(),60); // SF
AddStaticVehicleEx(403,-2038.8365,138.2532,29.4407,270.3675,PVA(),PVA(),60); // SF
AddStaticVehicleEx(403,-2038.6422,132.3828,29.4418,270.1570,PVA(),PVA(),60); // SF

AddStaticVehicleEx(475,1093.3403,-1377.2522,13.5852,179.0950,PVA(),PVA(),60); // LS
AddStaticVehicleEx(411,1101.9017,-1380.9474,13.5066,181.6889,PVA(),PVA(),60); // LS
AddStaticVehicleEx(411,1107.0326,-1382.5881,13.5503,179.2694,PVA(),PVA(),60); // LS

AddStaticVehicleEx(416,1898.4258,621.3808,11.0752,359.0374,PVA(),PVA(),60); // Ambulancia
AddStaticVehicleEx(416,1929.3595,621.1734,11.1303,0.1440,PVA(),PVA(),60); // Ambulancia

AddStaticVehicleEx(537,-1947.1777,-114.2865,25.4395,177.3084,PVA(),PVA(),60); // TREM FREIGHT
AddStaticVehicleEx(537,-1970.3407,-373.0453,25.4499,180.4985,PVA(),PVA(),60); // TREM FREIGHT

CreateObject(17901, -786.637, -3662.905, 131.509, 0.0, 0.0, 94.825);//parkour2

//==================== rampa radical 2 ==============================
CreateObject(8040,2873.3000000,-2937.2000000,727.2999900,0.0000000,0.0000000,0.0000000); //object(airprtcrprk02_lvs) (1)
CreateObject(621,2889.8999000,-2937.3999000,718.0000000,0.0000000,0.0000000,34.0000000); //object(veg_palm02) (1)
CreateObject(621,2884.8000000,-2937.3000000,717.7000100,0.0000000,0.0000000,38.0000000); //object(veg_palm02) (2)
CreateObject(621,2879.3999000,-2937.3000000,717.5000000,0.0000000,0.0000000,32.0000000); //object(veg_palm02) (3)
CreateObject(621,2874.0000000,-2937.2000000,717.5000000,0.0000000,0.0000000,0.0000000); //object(veg_palm02) (4)
CreateObject(621,2868.8000000,-2937.2000000,717.7000100,0.0000000,0.0000000,0.0000000); //object(veg_palm02) (5)
CreateObject(621,2863.3999000,-2937.3999000,717.5000000,0.0000000,0.0000000,0.0000000); //object(veg_palm02) (6)
CreateObject(621,2858.1001000,-2937.2000000,717.5000000,0.0000000,0.0000000,0.0000000); //object(veg_palm02) (7)
CreateObject(3472,2834.6001000,-2920.3999000,726.5000000,0.0000000,0.0000000,0.0000000); //object(circuslampost03) (1)
CreateObject(3472,2834.1001000,-2955.1001000,726.5000000,0.0000000,0.0000000,0.0000000); //object(circuslampost03) (2)
CreateObject(3472,2912.5000000,-2919.3000000,726.5000000,0.0000000,0.0000000,0.0000000); //object(circuslampost03) (3)
CreateObject(3472,2912.5000000,-2955.0000000,726.5000000,0.0000000,0.0000000,0.0000000); //object(circuslampost03) (4)
CreateObject(3524,2912.5000000,-2946.8999000,729.7000100,0.0000000,0.0000000,268.0000000); //object(skullpillar01_lvs) (1)
CreateObject(3524,2912.6001000,-2928.1001000,729.4000200,0.0000000,0.0000000,270.0000000); //object(skullpillar01_lvs) (2)
CreateObject(10838,2912.7000000,-2937.8000000,739.7999900,0.0000000,0.0000000,0.0000000); //object(airwelcomesign_sfse) (1)
CreateObject(11435,2897.3999000,-2950.7000000,731.2000100,0.0000000,0.0000000,0.0000000); //object(des_indsign1) (1)
CreateObject(13831,2871.3000000,-2906.5000000,739.0000000,0.0000000,0.0000000,0.0000000); //object(vinesign1_cunte01) (1)
CreateObject(8150,2849.5000000,-2956.2000000,730.0999800,0.0000000,0.0000000,0.0000000); //object(vgsselecfence04) (1)
CreateObject(987,2913.0000000,-2946.8000000,728.0000000,0.0000000,0.0000000,268.0000000); //object(elecfence_bar) (1)
CreateObject(1082,2834.0000000,-2936.1001000,730.5000000,0.0000000,0.0000000,0.0000000); //object(wheel_gn1) (1)
CreateObject(1082,2834.0000000,-2931.8999000,730.5999800,0.0000000,0.0000000,0.0000000); //object(wheel_gn1) (2)
CreateObject(1082,2834.0000000,-2940.1001000,730.5999800,0.0000000,0.0000000,0.0000000); //object(wheel_gn1) (3)
CreateObject(18450,2952.6001000,-2937.5000000,726.2000100,0.0000000,0.0000000,0.0000000); //object(cs_roadbridge04) (1)
CreateObject(18450,2992.6001000,-2937.5000000,726.2000100,0.0000000,0.0000000,0.0000000); //object(cs_roadbridge04) (2)
CreateObject(18450,3032.6001000,-2937.5000000,726.2000100,0.0000000,0.0000000,0.0000000); //object(cs_roadbridge04) (4)
CreateObject(8210,2940.6001000,-2945.3000000,729.7999900,0.0000000,0.0000000,0.0000000); //object(vgsselecfence12) (1)
CreateObject(8210,2993.8000000,-2944.8999000,729.7999900,0.0000000,0.0000000,0.0000000); //object(vgsselecfence12) (3)
CreateObject(8210,3045.0000000,-2944.8000000,729.7999900,0.0000000,0.0000000,0.0000000); //object(vgsselecfence12) (4)
CreateObject(8210,2940.0000000,-2930.1001000,729.9000200,0.0000000,0.0000000,180.0000000); //object(vgsselecfence12) (5)
CreateObject(8210,2994.3000000,-2930.1001000,729.9000200,0.0000000,0.0000000,179.9950000); //object(vgsselecfence12) (6)
CreateObject(8210,3045.3000000,-2929.8999000,729.9000200,0.0000000,0.0000000,179.9950000); //object(vgsselecfence12) (7)
CreateObject(18450,3103.8999000,-2937.3999000,701.5999800,0.0000000,38.0000000,0.0000000); //object(cs_roadbridge04) (5)
CreateObject(18450,3157.5000000,-2937.5000000,659.7999900,0.0000000,37.9960000,0.0000000); //object(cs_roadbridge04) (6)
CreateObject(18450,3211.2000000,-2937.6001000,617.7000100,0.0000000,37.9960000,0.0000000); //object(cs_roadbridge04) (9)
CreateObject(18450,3272.0000000,-2937.6001000,570.0999800,0.0000000,37.9960000,0.0000000); //object(cs_roadbridge04) (10)
CreateObject(1634,3302.8999000,-2932.8999000,547.0999800,330.0000000,0.0000000,268.0000000); //object(landjump2) (1)
CreateObject(1634,3302.8000000,-2937.1001000,547.2000100,329.9960000,0.0000000,269.9950000); //object(landjump2) (2)
CreateObject(1634,3302.8000000,-2941.0000000,547.2000100,329.9960000,0.0000000,269.9950000); //object(landjump2) (3)
//========================================================================================


//BONDES EM ESTAÇÕES
AddStaticVehicleEx(449,1733.2308,-1954.1517,13.5469,89.4318,PVA(),PVA(),60);
AddStaticVehicleEx(449,1434.4548,2632.3264,10.8203,179.1270,PVA(),PVA(),60);
AddStaticVehicleEx(449,-1947.8599,139.3281,25.7109,178.8205,PVA(),PVA(),60);
AddStaticVehicleEx(449,2867.1504,1293.0634,10.8203,94.1459,PVA(),PVA(),60);
AddStaticVehicleEx(449,812.2148,-1368.4412,-1.6689,314.7155,PVA(),PVA(),60);

//BONDES ESPALHADOS PELO MAPA
AddStaticVehicleEx(449,-155.6311,-1028.0300,11.7009,106.3249,PVA(),PVA(),60);
AddStaticVehicleEx(449,-265.9036,-1104.6458,23.8957,145.2713,PVA(),PVA(),60);
AddStaticVehicleEx(449,-735.1147,-1130.3289,60.9119,115.5336,PVA(),PVA(),60);
AddStaticVehicleEx(449,-1949.1329,-219.4322,26.1223,353.8549,PVA(),PVA(),60);
AddStaticVehicleEx(449,-1944.4863,-39.4736,26.1223,359.8910,PVA(),PVA(),60);
AddStaticVehicleEx(449,-1944.3750,48.6927,26.1223,0.0000,PVA(),PVA(),60);
AddStaticVehicleEx(449,-1939.5947,206.1305,25.9302,352.9907,PVA(),PVA(),60);
AddStaticVehicleEx(449,-1564.9207,538.0882,33.7186,305.9281,PVA(),PVA(),60);
AddStaticVehicleEx(449,-860.0049,1050.4470,34.9973,306.0781,PVA(),PVA(),60);
AddStaticVehicleEx(449,-332.3138,1247.1580,30.5983,284.9322,PVA(),PVA(),60);
AddStaticVehicleEx(449,255.6051,1224.7720,23.2473,253.0479,PVA(),PVA(),60);
AddStaticVehicleEx(449,742.0444,1845.3538,6.1760,0.4493,PVA(),PVA(),60);
AddStaticVehicleEx(449,726.8629,2400.9077,20.2086,355.8552,PVA(),PVA(),60);
AddStaticVehicleEx(449,1263.1460,2632.2500,11.2473,270.0016,PVA(),PVA(),60);
AddStaticVehicleEx(449,2541.3423,2590.3989,11.2473,195.6753,PVA(),PVA(),60);
AddStaticVehicleEx(449,2781.0000,1824.4637,11.2473,180.0000,PVA(),PVA(),60);
AddStaticVehicleEx(449,2859.5054,1518.9614,11.2473,194.4158,PVA(),PVA(),60);
AddStaticVehicleEx(449,2827.5669,20.6641,29.1574,180.2452,PVA(),PVA(),60);
AddStaticVehicleEx(449,2759.0012,-257.1891,20.5295,149.8998,PVA(),PVA(),60);
AddStaticVehicleEx(449,2284.8750,-1193.9558,25.8433,180.0000,PVA(),PVA(),60);
AddStaticVehicleEx(449,2203.9536,-1673.7180,14.9429,168.3121,PVA(),PVA(),60);
AddStaticVehicleEx(449,1771.9537,-1953.8003,13.9973,89.9383,PVA(),PVA(),60);

AddStaticVehicleEx(411,2039.6630,885.9023,6.9884,179.9606,PVA(),PVA(),60); // AVENIDA
AddStaticVehicleEx(411,2074.5447,1172.4824,10.3754,0.1314,PVA(),PVA(),60); // AVENIDA
AddStaticVehicleEx(411,2074.3997,1562.9937,10.3990,0.1842,PVA(),PVA(),60); // AVENIDA
AddStaticVehicleEx(411,2154.9023,1966.5576,10.3990,1.0012,PVA(),PVA(),60); // AVENIDA
AddStaticVehicleEx(411,2154.9485,2192.8562,10.3990,358.7644,PVA(),PVA(),60); // AVENIDA
AddStaticVehicleEx(411,2119.9685,1889.0989,10.3990,180.5224,PVA(),PVA(),60); // AVENIDA
AddStaticVehicleEx(411,2040.3132,1544.5917,10.3990,179.8601,PVA(),PVA(),60); // AVENIDA
AddStaticVehicleEx(411,2039.8164,1209.7527,10.3991,180.2782,PVA(),PVA(),60); // AVENIDA

//TRENS STREAK
AddStaticVehicleEx(538,-1948.5500,72.8434,25.7186,276.5959,PVA(),PVA(),60);
AddStaticVehicleEx(538,-615.0374,-1148.2159,42.3656,235.4129,PVA(),PVA(),60);
AddStaticVehicleEx(538,1688.5205,-1957.1829,13.4740,269.3165,PVA(),PVA(),60);
AddStaticVehicleEx(538,2209.8804,-1655.5034,14.8972,347.0021,PVA(),PVA(),60);
AddStaticVehicleEx(538,2868.5669,1241.0671,10.7330,8.6020,PVA(),PVA(),60);

AddStaticVehicleEx(475,2118.6013,956.4501,10.6118,89.4425,PVA(),PVA(),60); // AVENIDA POSTO DO AMMU

AddStaticVehicleEx(411,2211.2524,2473.2927,10.4985,176.0367,PVA(),PVA(),60); // DELEGACIA POSTO
AddStaticVehicleEx(541,2193.4978,2472.6218,10.4578,179.0361,PVA(),PVA(),60); // DELEGACIA POSTO
AddStaticVehicleEx(598,2282.1511,2475.7502,10.5943,180.3145,PVA(),PVA(),60); // DELEGACIA

AddStaticVehicleEx(476,-1580.9094,-271.1870,14.8539,44.9582,PVA(),PVA(),60); // AEROSF
AddStaticVehicleEx(476,-1597.9785,-288.3651,14.8628,44.8093,PVA(),PVA(),60); // AEROSF
AddStaticVehicleEx(476,-1614.5343,-305.1128,14.8579,45.2021,PVA(),PVA(),60); // AEROSF

AddStaticVehicleEx(476,1273.2882,1360.5236,11.5179,268.2368,PVA(),PVA(),60); // AEROLV
AddStaticVehicleEx(476,1272.3185,1324.1112,11.5220,267.4556,PVA(),PVA(),60); // AEROLV
AddStaticVehicleEx(411,1282.2252,1303.8514,10.5474,270.1215,PVA(),PVA(),60); // AEROLV

AddStaticVehicleEx(476,326.0776,2540.5654,17.5178,181.1292,PVA(),PVA(),60); // AEROAB
AddStaticVehicleEx(476,291.2197,2541.3052,17.5358,178.8199,PVA(),PVA(),60); // AEROAB
AddStaticVehicleEx(476,189.3840,2541.0481,17.2784,178.2362,PVA(),PVA(),60); // RUSTLER
AddStaticVehicleEx(476,217.0173,2540.5652,17.3022,177.9986,PVA(),PVA(),60); // RUSTLER
AddStaticVehicleEx(476,244.0157,2539.2524,17.4477,177.5188,PVA(),PVA(),60); // RUSTLER
AddStaticVehicleEx(476,269.8799,2538.4795,17.4397,178.4939,PVA(),PVA(),60); // RUSTLER

AddStaticVehicleEx(451,2265.0664,646.8077,10.8343,0.7674,PVA(),PVA(),60); // SPAWN
AddStaticVehicleEx(541,1920.7505,1762.1171,18.5296,181.8511,PVA(),PVA(),60); // SPAWN
AddStaticVehicleEx(411,1924.7302,1783.6023,18.6327,1.6480,PVA(),PVA(),60); // SPAWN
AddStaticVehicleEx(451,1970.1776,1751.2404,18.6412,1.6474,PVA(),PVA(),60); // SPAWN
AddStaticVehicleEx(411,1440.8416,2015.2239,10.5474,0.3651,PVA(),PVA(),60); // SPAWN
AddStaticVehicleEx(475,1430.7817,2015.7555,10.6245,357.6791,PVA(),PVA(),60); // SPAWN
AddStaticVehicleEx(451,1452.8947,2016.0302,10.5284,4.4121,PVA(),PVA(),60); // SPAWN
AddStaticVehicleEx(411,2075.5930,1000.4023,10.3990,358.8294,PVA(),PVA(),60); // AVENIDA
AddStaticVehicleEx(411,2360.2163,1990.8826,10.3984,0.5004,PVA(),PVA(),60); // VSTEAKS
AddStaticVehicleEx(541,2360.5120,2036.0776,10.2809,1.8356,PVA(),PVA(),60); // VSTEAKS
AddStaticVehicleEx(541,2339.6746,1995.7614,10.2968,180.0494,PVA(),PVA(),60); // VSTEAKS
AddStaticVehicleEx(411,2578.8374,1981.9679,10.5440,89.7462,PVA(),PVA(),60); // SPAWN
AddStaticVehicleEx(541,2590.3896,1967.0844,10.4452,180.8379,PVA(),PVA(),60); // SPAWN
AddStaticVehicleEx(475,2594.0349,1976.2781,10.6202,271.5881,PVA(),PVA(),60); // SPAWN
AddStaticVehicleEx(475,2563.6616,2058.8518,10.6229,359.9817,PVA(),PVA(),60); // AMMUNORTE
AddStaticVehicleEx(411,2571.9810,2058.5664,10.5474,1.2894,PVA(),PVA(),60); // AMMUNORTE
AddStaticVehicleEx(451,2588.2085,2056.8865,10.5279,267.3251,PVA(),PVA(),60); // AMMUNORTE
AddStaticVehicleEx(411,2610.5894,2279.4824,10.5474,269.9514,PVA(),PVA(),60); // VROCK
AddStaticVehicleEx(541,2610.5220,2262.5176,10.4451,270.7257,PVA(),PVA(),60); // VROCK
AddStaticVehicleEx(475,2594.5730,2250.5527,10.6251,179.0943,PVA(),PVA(),60); // VROCK
AddStaticVehicleEx(451,2564.8840,2257.8208,10.5273,88.3136,PVA(),PVA(),60); // VROCK
AddStaticVehicleEx(451,2828.3379,2368.0146,10.5266,88.6517,PVA(),PVA(),60); // LOJAS_ISOLADAS
AddStaticVehicleEx(541,2842.1145,2356.7612,10.4378,269.2549,PVA(),PVA(),60); // LOJAS_ISOLADAS
AddStaticVehicleEx(506,2827.2908,2334.7134,10.5204,90.6258,PVA(),PVA(),60); // LOJAS_ISOLADAS
AddStaticVehicleEx(411,2865.5442,2345.8789,10.5474,269.6060,PVA(),PVA(),60); // LOJAS_ISOLADAS
AddStaticVehicleEx(411,1538.0327,2214.6306,10.5474,178.6128,PVA(),PVA(),60); // BANDITS_ESTADIO
AddStaticVehicleEx(475,1531.0906,2203.0134,10.6235,0.8166,PVA(),PVA(),60); // BANDITS_ESTADIO
AddStaticVehicleEx(451,1525.6912,2257.8660,10.5273,359.7260,PVA(),PVA(),60); // BANDITS_ESTADIO
AddStaticVehicleEx(411,2461.6997,1629.7124,10.5474,179.3013,PVA(),PVA(),60); // LALONCA
AddStaticVehicleEx(506,2451.9482,1629.5139,10.5248,179.2871,PVA(),PVA(),60); // LALONCA
AddStaticVehicleEx(541,2409.0542,1630.0787,10.4467,180.6748,PVA(),PVA(),60); // LALONCA
AddStaticVehicleEx(411,2139.3035,1409.3379,10.5474,179.9613,PVA(),PVA(),60); // AUTOBAHN
AddStaticVehicleEx(451,2148.9629,1397.8735,10.5201,0.1406,PVA(),PVA(),60); // AUTOBAHN
AddStaticVehicleEx(411,2132.0242,988.3863,10.5474,180.5909,PVA(),PVA(),60); // SPAWN
AddStaticVehicleEx(411,2454.2241,1327.3563,10.5474,179.7144,PVA(),PVA(),60); // CARPARK
AddStaticVehicleEx(541,2461.6125,1335.9634,10.4453,359.6712,PVA(),PVA(),60); // CARPARK
AddStaticVehicleEx(451,2458.4780,1357.6846,10.5284,0.0884,PVA(),PVA(),60); // CARPARK
AddStaticVehicleEx(411,1987.9063,2412.0042,10.5474,181.5126,PVA(),PVA(),60); // SOUVERNIRS
AddStaticVehicleEx(451,2009.3309,2413.5825,10.5275,269.5063,PVA(),PVA(),60); // SOUVERNIRS
AddStaticVehicleEx(411,2441.2227,2021.0332,10.5474,89.4540,PVA(),PVA(),60); // BURGUER
AddStaticVehicleEx(451,2449.0854,1991.1738,10.5257,180.2337,PVA(),PVA(),60); // BURGUER
AddStaticVehicleEx(541,2472.2625,1991.0762,10.4454,181.6116,PVA(),PVA(),60); // BURGUER

AddStaticVehicle(562,-314.7210,1515.1760,75.0146,178.6429,93,101); // ELEGY_DRIFT
AddStaticVehicle(562,-318.1253,1515.0393,75.0166,179.9480,144,152); // ELEGY_DRIFT
AddStaticVehicle(562,-324.1825,1515.8026,75.0155,180.6812,144,152); // ELEGY_DRIFT
AddStaticVehicle(562,-327.4474,1515.6926,75.0165,180.0139,32,151); // ELEGY_DRIFT
AddStaticVehicle(562,-333.7806,1515.5006,75.0203,181.1130,32,159); // ELEGY_DRIFT
AddStaticVehicle(562,-336.8038,1515.1768,75.0176,181.1611,101,0); // ELEGY_DRIFT
AddStaticVehicle(562,-342.9200,1515.0565,75.0194,180.3314,0,147); // ELEGY_DRIFT

SSSArena[0] = AddStaticVehicle(411,-1663.5233,-209.3625,13.8755,313.1805,91,90); // INICIOARENA
SSSArena[1] = AddStaticVehicle(411,-1667.5096,-205.0081,13.8722,311.9215,114,105); // INICIOARENA
SSSArena[2] = AddStaticVehicle(411,-1671.7821,-201.3075,13.8755,314.3861,106,119); // INICIOARENA
SSSArena[3] = AddStaticVehicle(411,-1674.7408,-198.2387,13.8744,312.0795,48,42); // INICIOARENA
SSSArena[4] = AddStaticVehicle(411,-1677.9150,-194.8477,13.8735,314.4736,29,12); // INICIOARENA
SSSArena[5] = AddStaticVehicle(411,-1681.2183,-191.2715,13.8757,314.6590,92,119); // INICIOARENA
SSSArena[6] = AddStaticVehicle(411,-1684.1385,-188.5191,13.8710,313.5734,116,25); // INICIOARENA
SSSArena[7] = AddStaticVehicle(411,-1686.7559,-185.8334,13.8721,312.6374,103,115); // INICIOARENA
SSSArena[8] = AddStaticVehicle(531,-1689.9688,-183.8452,14.1354,314.5944,90,75); // INICIOARENA
SSSArena[9] = AddStaticVehicle(478,-1691.8860,-181.5642,14.1583,314.6398,7,72); // INICIOARENA
SSSArena[10] = AddStaticVehicle(411,-1683.7435,-173.0468,13.8823,314.5574,21,56); // INICIOARENA
SSSArena[11] = AddStaticVehicle(411,-1658.3225,-197.7553,13.8759,315.2685,22,106); // INICIOARENA
SSSArena[12] = AddStaticVehicle(406,-1661.3395,-191.1594,15.7041,315.0013,6,99); // INICIOARENA
SSSArena[13] = AddStaticVehicle(411,-1672.6469,-183.5290,13.8755,313.5949,104,69); // INICIOARENA
SSSArena[14] = AddStaticVehicle(463,-1673.9620,-180.5335,13.6819,319.4118,151,152); // INICIOARENA
SSSArena[15] = AddStaticVehicle(522,-1675.8245,-182.1236,13.6685,311.1651,85,82); // INICIOARENA
SSSArena[16] = AddStaticVehicle(481,-1677.6602,-181.2484,13.6641,309.9420,0,104); // INICIOARENA
SSSArena[17] = AddStaticVehicle(481,-1675.3514,-179.0978,13.6644,317.4641,63,95); // INICIOARENA
SSSArena[18] = AddStaticVehicle(411,-1678.6295,-178.2059,13.8803,314.9986,110,46); // INICIOARENA
SSSArena[19] = AddStaticVehicle(411,-1681.2513,-175.5445,13.8823,314.2559,63,11); // INICIOARENA

SURFAEROLS = AddStaticVehicle(519, 1936.2281, -2280.6382, 14.6318, 180.0000, 0, 0);

NV[0] = AddStaticVehicle(520,279.8260,1956.1022,18.3681,269.4594,44,6); // MD_HYDRA_A51
NV[1] = AddStaticVehicle(520,280.8492,1988.9280,18.3630,268.1555,111,87); // MD_HYDRA_A51
NV[2] = AddStaticVehicle(520,278.9382,2023.6930,18.3723,272.3112,48,76); // MD_HYDRA_A51
NV[3] = AddStaticVehicle(520,312.8345,2011.1025,18.3639,182.6004,31,53); // MD_HYDRA_A51
NV[4] = AddStaticVehicle(520,311.6844,2028.3810,18.3636,185.3764,116,26); // MD_HYDRA_A51
NV[5] = AddStaticVehicle(520,300.1274,2026.9866,18.3639,185.1089,14,63); // MD_HYDRA_A51
NV[6] = AddStaticVehicle(520,304.7506,2040.1150,18.3640,176.9971,54,35); // MD_HYDRA_A51
NV[7] = AddStaticVehicle(520,317.7108,2040.7426,18.3639,179.7898,4,68); // MD_HYDRA_A51
NV[8] = AddStaticVehicle(520,311.7513,2051.7139,18.3640,175.6280,95,12); // MD_HYDRA_A51
NV[9] = AddStaticVehicle(520,301.3426,2055.4487,18.3639,177.6048,33,50); // MD_HYDRA_A51
NV[10] = AddStaticVehicle(432,-536.0496,2637.1631,53.4272,271.2385,17,6); // MD_RHINO_R
NV[11] = AddStaticVehicle(432,-535.7098,2630.4153,53.4236,269.5337,69,18); // MD_RHINO_R
NV[12] = AddStaticVehicle(432,-536.1105,2621.7788,53.4300,267.9724,88,113); // MD_RHINO_R
NV[13] = AddStaticVehicle(432,-536.2634,2613.5503,53.4264,270.6752,46,19); // MD_RHINO_R
NV[14] = AddStaticVehicle(432,-536.6967,2605.9939,53.4278,268.4352,43,35); // MD_RHINO_R
NV[15] = AddStaticVehicle(432,-536.5426,2596.7913,53.4263,267.6514,73,42); // MD_RHINO_R
NV[16] = AddStaticVehicle(432,-537.0333,2587.6650,53.4300,265.8683,23,105); // MD_RHINO_R
NV[17] = AddStaticVehicle(432,-537.5192,2578.9104,53.4222,269.9218,53,31); // MD_RHINO_R
NV[18] = AddStaticVehicle(432,-537.2989,2569.9656,53.4271,269.3576,93,85); // MD_RHINO_R
NV[19] = AddStaticVehicle(447,-767.1992,1803.1460,0.8859,191.0066,121,60); // MD_SEASP_SD
NV[20] = AddStaticVehicle(447,-771.4254,1820.1752,0.9014,193.7623,21,31); // MD_SEASP_SD
NV[21] = AddStaticVehicle(447,-776.4999,1839.9290,0.8522,193.5905,42,7); // MD_SEASP_SD
NV[22] = AddStaticVehicle(447,-782.6037,1863.7367,0.8672,194.1392,47,122); // MD_SEASP_SD
NV[23] = AddStaticVehicle(447,-788.6933,1887.0488,0.7940,191.6930,76,53); // MD_SEASP_SD
NV[24] = AddStaticVehicle(447,-792.8019,1903.5238,0.8467,194.0741,96,74); // MD_SEASP_SD
NV[25] = AddStaticVehicle(447,-799.0168,1927.8645,0.9403,194.0314,68,22); // MD_SEASP_SD
NV[26] = AddStaticVehicle(447,-804.2618,1948.4480,0.8565,193.2370,63,20); // MD_SEASP_SD
NV[27] = AddStaticVehicle(447,-808.0245,1963.6688,0.8335,193.9809,78,115); // MD_SEASP_SD
NV[28] = AddStaticVehicle(425,203.0419,2505.7922,17.0589,92.6407,124,43); // MD_HUNTER_AEROAB
NV[29] = AddStaticVehicle(425,229.8955,2505.6428,17.0556,88.9221,27,40); // MD_HUNTER_AEROAB
NV[30] = AddStaticVehicle(425,269.7905,2504.5745,17.0557,81.2860,6,31); // MD_HUNTER_AEROAB
NV[31] = AddStaticVehicle(425,298.2977,2503.0398,17.0546,92.4630,74,97); // MD_HUNTER_AEROAB
NV[32] = AddStaticVehicle(425,340.5423,2503.9858,17.0549,88.4989,35,54); // MD_HUNTER_AEROAB
NV[33] = AddStaticVehicle(425,362.9616,2503.7266,17.0551,90.3531,70,109); // MD_HUNTER_AEROAB
NV[34] = AddStaticVehicle(425,395.8781,2503.3435,17.0653,89.2763,118,37); // MD_HUNTER_AEROAB
NV[35] = AddStaticVehicle(425,420.1077,2501.9482,17.0355,88.1186,36,89); // MD_HUNTER_AEROAB

PVC_VeiculosObjetosCarro[0] = AddStaticVehicleEx(411, 1252.2314,-1369.3060, 13.0239,179.0000, -1, -1, 15);
PVC_VeiculosObjetosCarro[1] = AddStaticVehicleEx(402, 1256.1715,-1369.7603, 13.0239,179.0000, -1, -1, 15);
PVC_VeiculosObjetosCarro[2] = AddStaticVehicleEx(451, 1259.9972, -1369.8378, 13.0239,179.0000, -1, -1, 15);
PVC_VeiculosObjetosCarro[3] = AddStaticVehicleEx(541, 1263.7948,-1369.7164, 13.0239,178.9400, -1, -1, 15);
PVC_VeiculosObjetosCarro[4] = AddStaticVehicleEx(411, 1345.1982,-1429.6093, 13.1857,-2.0000, -1, -1, 15);
PVC_VeiculosObjetosCarro[5] = AddStaticVehicleEx(402, 1341.9358,-1429.0669, 13.1857,-2.0000, -1, -1, 15);
PVC_VeiculosObjetosCarro[6] = AddStaticVehicleEx(451, 1338.6406,-1428.7621, 13.1857,-2.0000, -1, -1, 15);
PVC_VeiculosObjetosCarro[7] = AddStaticVehicleEx(411, 541.7786,-1443.3008, 15.2494,4.0000, -1, -1, 15);
PVC_VeiculosObjetosCarro[8] = AddStaticVehicleEx(402, 537.7968,-1443.3483, 15.2494,4.0000, -1, -1, 15);
PVC_VeiculosObjetosCarro[9] = AddStaticVehicleEx(451, 533.6580,-1443.4612, 15.2494,4.0000, -1, -1, 15);
PVC_VeiculosObjetosCarro[10] = AddStaticVehicleEx(541, 529.6241,-1443.7673, 15.2494,4.0000, -1, -1, 15);
PVC_VeiculosObjetosCarro[11] = AddStaticVehicleEx(402, 517.7130,-1390.4261, 15.6812,197.0000, -1, -1, 15);
PVC_VeiculosObjetosCarro[12] = AddStaticVehicleEx(451, 521.5855,-1389.2000, 15.6812,194.0000, -1, -1, 15);
PVC_VeiculosObjetosCarro[13] = AddStaticVehicleEx(541, 525.7188,-1388.0344, 15.6812,192.0000, -1, -1, 15);
PVC_VeiculosObjetosCarro[14] = AddStaticVehicleEx(411, 525.7213,-1444.9691, 15.0929,0.0000, -1, -1, 15);

PVC_VeiculosObjetosMoto[0] = AddStaticVehicleEx(522, 1252.2314,-1369.3060, 13.0239,179.0000, -1, -1, 15);
PVC_VeiculosObjetosMoto[1] = AddStaticVehicleEx(521, 1256.1715,-1369.7603, 13.0239,179.0000, -1, -1, 15);
PVC_VeiculosObjetosMoto[2] = AddStaticVehicleEx(522, 1259.9972, -1369.8378, 13.0239,179.0000, -1, -1, 15);
PVC_VeiculosObjetosMoto[3] = AddStaticVehicleEx(521, 1263.7948,-1369.7164, 13.0239,178.9400, -1, -1, 15);
PVC_VeiculosObjetosMoto[4] = AddStaticVehicleEx(522, 1345.1982,-1429.6093, 13.1857,-2.0000, -1, -1, 15);
PVC_VeiculosObjetosMoto[5] = AddStaticVehicleEx(521, 1341.9358,-1429.0669, 13.1857,-2.0000, -1, -1, 15);
PVC_VeiculosObjetosMoto[6] = AddStaticVehicleEx(522, 1338.6406,-1428.7621, 13.1857,-2.0000, -1, -1, 15);
PVC_VeiculosObjetosMoto[7] = AddStaticVehicleEx(521, 541.7786,-1443.3008, 15.2494,4.0000, -1, -1, 15);
PVC_VeiculosObjetosMoto[8] = AddStaticVehicleEx(522, 537.7968,-1443.3483, 15.2494,4.0000, -1, -1, 15);
PVC_VeiculosObjetosMoto[9] = AddStaticVehicleEx(521, 533.6580,-1443.4612, 15.2494,4.0000, -1, -1, 15);
PVC_VeiculosObjetosMoto[10] = AddStaticVehicleEx(522, 529.6241,-1443.7673, 15.2494,4.0000, -1, -1, 15);
PVC_VeiculosObjetosMoto[11] = AddStaticVehicleEx(521, 517.7130,-1390.4261, 15.6812,197.0000, -1, -1, 15);
PVC_VeiculosObjetosMoto[12] = AddStaticVehicleEx(522, 521.5855,-1389.2000, 15.6812,194.0000, -1, -1, 15);
PVC_VeiculosObjetosMoto[13] = AddStaticVehicleEx(521, 525.7188,-1388.0344, 15.6812,192.0000, -1, -1, 15);
PVC_VeiculosObjetosMoto[14] = AddStaticVehicleEx(522, 525.7213,-1444.9691, 15.0929,0.0000, -1, -1, 15);

//LADRAO
PL_Veiculos[0] = AddStaticVehicleEx(411, -1652.2372, 3.1476, 3.2637, 105.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[1] = AddStaticVehicleEx(536, -1653.8005, 8.3612, 3.2622, 103.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[2] = AddStaticVehicleEx(562, -1716.6775, -26.1684, 3.1798, 174.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[3] = AddStaticVehicleEx(562, -1686.0305, 0.9835, 3.1804, 178.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[4] = AddStaticVehicleEx(496, -1699.3525, -11.8491, 3.2682, 178.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[5] = AddStaticVehicleEx(522, -1738.3717, -30.0452, 3.0884, 164.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[6] = AddStaticVehicleEx(517, -1736.6266, -43.0913, 3.2710, 33.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[7] = AddStaticVehicleEx(522, -1736.6589, -30.3044, 3.0884, 164.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[8] = AddStaticVehicleEx(549, -1708.8999, -20.3129, 3.1798, 174.0000, -1, -1, PL_TempSpawn);
//POLICIA
PL_Veiculos[9] = AddStaticVehicleEx(490, -1581.6294, 652.3788, 7.2668, 0.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[10] = AddStaticVehicleEx(528, -1593.6243, 652.7297, 7.2668, 0.000, -1, -1, PL_TempSpawn);
PL_Veiculos[11] = AddStaticVehicleEx(596, -1604.9194, 652.5292, 7.2668, 0.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[12] = AddStaticVehicleEx(523, -1616.2039, 652.5666, 7.2668, 0.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[13] = AddStaticVehicleEx(523, -1622.6044, 652.6773, 7.2668, 0.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[14] = AddStaticVehicleEx(523, -1604.6533, 724.7123, 11.2473, -84.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[15] = AddStaticVehicleEx(470, -1582.1788, 672.7244, 7.0867, 180.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[16] = AddStaticVehicleEx(427, -1588.8708, 671.5631, 7.4499, 178.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[17] = AddStaticVehicleEx(523, -1606.1234, 672.8716, 6.7219, 222.0000, -1, -1, PL_TempSpawn);
//ROUBAR
PL_Veiculos[18] = AddStaticVehicleEx(562, -1948.3875, 272.5020, 40.7705, 69.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[19] = AddStaticVehicleEx(565, -1948.2250, 267.6268, 40.7705, 69.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[20] = AddStaticVehicleEx(589, -1948.6014, 263.0377, 40.7705, 69.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[21] = AddStaticVehicleEx(603, -1948.9861, 259.0517, 41.2186, 67.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[22] = AddStaticVehicleEx(409, -1957.4402, 300.2663, 35.2392, 113.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[23] = AddStaticVehicleEx(409, -1956.5564, 295.0984, 35.2392, 113.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[24] = AddStaticVehicleEx(434, -1948.7457, 272.6381, 35.4212, 113.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[25] = AddStaticVehicleEx(451, -1948.4778, 266.6312, 35.1903, 69.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[26] = AddStaticVehicleEx(463, -1950.2231, 259.9125, 35.0100, 50.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[27] = AddStaticVehicleEx(522, -1951.6222, 258.1873, 35.0100, 50.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[28] = AddStaticVehicleEx(535, -1955.1580, 294.8524, 40.8340, 114.0000, -1, -1, PL_TempSpawn);
PL_Veiculos[29] = AddStaticVehicleEx(411, -1955.7018, 302.5274, 40.8340, 114.0000, -1, -1, PL_TempSpawn);

SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[0], 225);
SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[1], 225);
SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[2], 225);
SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[3], 225);
SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[4], 225);
SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[5], 225);
SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[6], 225);
SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[7], 225);
SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[8], 225);
SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[9], 225);
SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[10], 225);
SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[11], 225);
SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[12], 225);
SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[13], 225);
SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[14], 225);

SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[0], 224);
SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[1], 224);
SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[2], 224);
SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[3], 224);
SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[4], 224);
SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[5], 224);
SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[6], 224);
SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[7], 224);
SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[8], 224);
SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[9], 224);
SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[10], 224);
SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[11], 224);
SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[12], 224);
SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[13], 224);
SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[14], 224);

SetVehicleVirtualWorld(PL_Veiculos[0], 2626);
SetVehicleVirtualWorld(PL_Veiculos[1], 2626);
SetVehicleVirtualWorld(PL_Veiculos[2], 2626);
SetVehicleVirtualWorld(PL_Veiculos[3], 2626);
SetVehicleVirtualWorld(PL_Veiculos[4], 2626);
SetVehicleVirtualWorld(PL_Veiculos[5], 2626);
SetVehicleVirtualWorld(PL_Veiculos[6], 2626);
SetVehicleVirtualWorld(PL_Veiculos[7], 2626);
SetVehicleVirtualWorld(PL_Veiculos[8], 2626);
SetVehicleVirtualWorld(PL_Veiculos[9], 2626);
SetVehicleVirtualWorld(PL_Veiculos[10], 2626);
SetVehicleVirtualWorld(PL_Veiculos[11], 2626);
SetVehicleVirtualWorld(PL_Veiculos[12], 2626);
SetVehicleVirtualWorld(PL_Veiculos[13], 2626);
SetVehicleVirtualWorld(PL_Veiculos[14], 2626);
SetVehicleVirtualWorld(PL_Veiculos[15], 2626);
SetVehicleVirtualWorld(PL_Veiculos[16], 2626);
SetVehicleVirtualWorld(PL_Veiculos[17], 2626);
SetVehicleVirtualWorld(PL_Veiculos[18], 2626);
SetVehicleVirtualWorld(PL_Veiculos[19], 2626);
SetVehicleVirtualWorld(PL_Veiculos[20], 2626);
SetVehicleVirtualWorld(PL_Veiculos[21], 2626);
SetVehicleVirtualWorld(PL_Veiculos[22], 2626);
SetVehicleVirtualWorld(PL_Veiculos[23], 2626);
SetVehicleVirtualWorld(PL_Veiculos[24], 2626);
SetVehicleVirtualWorld(PL_Veiculos[25], 2626);
SetVehicleVirtualWorld(PL_Veiculos[26], 2626);
SetVehicleVirtualWorld(PL_Veiculos[27], 2626);
SetVehicleVirtualWorld(PL_Veiculos[28], 2626);
SetVehicleVirtualWorld(PL_Veiculos[29], 2626);

SetVehicleVirtualWorld(SURFAEROLS, 1000);
SetVehicleVirtualWorld(NV[0], 18);
SetVehicleVirtualWorld(NV[1], 18);
SetVehicleVirtualWorld(NV[2], 18);
SetVehicleVirtualWorld(NV[3], 18);
SetVehicleVirtualWorld(NV[4], 18);
SetVehicleVirtualWorld(NV[5], 18);
SetVehicleVirtualWorld(NV[6], 18);
SetVehicleVirtualWorld(NV[7], 18);
SetVehicleVirtualWorld(NV[8], 18);
SetVehicleVirtualWorld(NV[9], 18);
SetVehicleVirtualWorld(NV[10], 18);
SetVehicleVirtualWorld(NV[11], 18);
SetVehicleVirtualWorld(NV[12], 18);
SetVehicleVirtualWorld(NV[13], 18);
SetVehicleVirtualWorld(NV[14], 18);
SetVehicleVirtualWorld(NV[15], 18);
SetVehicleVirtualWorld(NV[16], 18);
SetVehicleVirtualWorld(NV[17], 18);
SetVehicleVirtualWorld(NV[18], 18);
SetVehicleVirtualWorld(NV[19], 18);
SetVehicleVirtualWorld(NV[20], 18);
SetVehicleVirtualWorld(NV[21], 18);
SetVehicleVirtualWorld(NV[22], 18);
SetVehicleVirtualWorld(NV[23], 18);
SetVehicleVirtualWorld(NV[24], 18);
SetVehicleVirtualWorld(NV[25], 18);
SetVehicleVirtualWorld(NV[26], 18);
SetVehicleVirtualWorld(NV[27], 18);
SetVehicleVirtualWorld(NV[28], 18);
SetVehicleVirtualWorld(NV[29], 18);
SetVehicleVirtualWorld(NV[30], 18);
SetVehicleVirtualWorld(NV[31], 18);
SetVehicleVirtualWorld(NV[32], 18);
SetVehicleVirtualWorld(NV[33], 18);
SetVehicleVirtualWorld(NV[34], 18);
SetVehicleVirtualWorld(NV[35], 18);


SetVehicleVirtualWorld(SSSArena[0], 21);
SetVehicleVirtualWorld(SSSArena[1], 21);
SetVehicleVirtualWorld(SSSArena[2], 21);
SetVehicleVirtualWorld(SSSArena[3], 21);
SetVehicleVirtualWorld(SSSArena[4], 21);
SetVehicleVirtualWorld(SSSArena[5], 21);
SetVehicleVirtualWorld(SSSArena[6], 21);
SetVehicleVirtualWorld(SSSArena[7], 21);
SetVehicleVirtualWorld(SSSArena[8], 21);
SetVehicleVirtualWorld(SSSArena[9], 21);
SetVehicleVirtualWorld(SSSArena[10], 21);
SetVehicleVirtualWorld(SSSArena[11], 21);
SetVehicleVirtualWorld(SSSArena[12], 21);
SetVehicleVirtualWorld(SSSArena[13], 21);
SetVehicleVirtualWorld(SSSArena[14], 21);
SetVehicleVirtualWorld(SSSArena[15], 21);
SetVehicleVirtualWorld(SSSArena[16], 21);
SetVehicleVirtualWorld(SSSArena[17], 21);
SetVehicleVirtualWorld(SSSArena[18], 21);
SetVehicleVirtualWorld(SSSArena[19], 21);





//CLASSES
AddPlayerClass(3,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);
AddPlayerClass(4,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);
AddPlayerClass(5,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);
AddPlayerClass(6,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);
AddPlayerClass(8,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);
AddPlayerClass(42,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);
AddPlayerClass(65,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);
AddPlayerClass(86,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);
AddPlayerClass(119,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);
AddPlayerClass(149,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);
AddPlayerClass(208,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);
AddPlayerClass(273,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);
AddPlayerClass(289,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);

AddPlayerClass(280,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);
AddPlayerClass(281,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);
AddPlayerClass(282,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);
AddPlayerClass(283,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(284,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(285,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(286,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(287,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(254,1958.3783,1343.1572,15.3746,0.0,0,0,24,300,-1,-1);
AddPlayerClass(255,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(256,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(257,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(258,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(259,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(260,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(261,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(262,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(263,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(264,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(274,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(275,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(276,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(290,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(291,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(292,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(293,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(294,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(295,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(296,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(297,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(298,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(299,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(277,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(278,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(279,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(288,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(47,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(48,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(49,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(50,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(51,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(52,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(53,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(54,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(55,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(56,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(57,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(58,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(59,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(60,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(61,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(62,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(63,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(64,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(66,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(67,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(68,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(69,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(70,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(71,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(72,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(73,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(75,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(76,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(78,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(79,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(80,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(81,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(82,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(83,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(84,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(85,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(87,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(88,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(89,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(91,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(92,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(93,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(95,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(96,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(97,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(98,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(99,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(100,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(101,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(102,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(103,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(104,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(105,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(106,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(107,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(108,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(109,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(110,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(111,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(112,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(113,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(114,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(115,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(116,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(117,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(118,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(120,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(121,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(122,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(123,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(124,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(125,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(126,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(127,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(128,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(129,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(131,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(133,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(134,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(135,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(136,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(137,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(138,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(139,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(140,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(141,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(142,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(143,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(144,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(145,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(146,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(147,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(148,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(150,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(151,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(152,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(153,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(154,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(155,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(156,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(157,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(158,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(159,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(160,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(161,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(162,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(163,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(164,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(165,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(166,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(167,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(168,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(169,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(170,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(171,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(172,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(173,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(174,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(175,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(176,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(177,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(178,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(179,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(180,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(181,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(182,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(183,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(184,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(185,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(186,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(187,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(188,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(189,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(190,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(191,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(192,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(193,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(194,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(195,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(196,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(197,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(198,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(199,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(200,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(201,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(202,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(203,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(204,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(205,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(206,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(207,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(209,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(210,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(211,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(212,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(213,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(214,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(215,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(216,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(217,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(218,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(219,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(220,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(221,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(222,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(223,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(224,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(225,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(226,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(227,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(228,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(229,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(230,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(231,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(232,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(233,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(234,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(235,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(236,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(237,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(238,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(239,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(240,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(241,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(242,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(243,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(244,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(245,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(246,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(247,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(248,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(249,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(250,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(251,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
AddPlayerClass(253,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);

AddStaticVehicle(411,1011.9031,-660.8151,120.8682,32.3037,3,3); // ruan
UltimoVeiculoGM = AddStaticVehicle(411,1006.9547,-663.9280,120.8424,32.1693,6,6); // ruan
for(new i; i < MAX_VEHICLES; i++){AutoTune(i);}//TUNAR TUDO

//Marcas no mapa
ShowPlayerMarkers(1);

//CONFIGURAÇÃO E INIS
printf("  Carregando cofigurações...");
if(!dini_Exists("ZNS.ini")) dini_Create("ZNS.ini");
LoadConfig();
return 1;
}



public SendPlayerFormattedText(playerid, COLOR, const str[], define)
{
	new tmpbuf[128];
	format(tmpbuf, sizeof(tmpbuf), str, define);
	SendClientMessage(playerid, COLOR, tmpbuf);
}

public SendAllFormattedText(COLOR, const str[], define)
{
	new tmpbuf[128];
	format(tmpbuf, sizeof(tmpbuf), str, define);
	SendClientMessageToAll(COLOR, tmpbuf);
}

forward ColocarPlayerEmSeuVeiculo(playerid);
public ColocarPlayerEmSeuVeiculo(playerid){
if(!IsPlayerSpawned(playerid)){return SendClientMessage(playerid, COLOUR_AVISO, "[AVISO]: Veículo não localizado. Motivo: Você ainda não nasceu.");}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_AVISO, "[AVISO]: Você está em uma arena. Não foi possível localizar o veículo.");
if(Arena2[playerid] == 1) return SendClientMessage(playerid, COLOUR_AVISO, "[AVISO]: Você está em uma arena. Não foi possível localizar o veículo.");
if(GetPlayerState(playerid)!= PLAYER_STATE_ONFOOT) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: MV: Você precisa estar a pé para usar este comando");
if(NoEvento[playerid] == 1 && EventoProibirCS == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está em um evento. Para sair: /sair");
if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está dentro de um interior.");
if(GetTotalLifeInt(playerid) < 60) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está com o life muito baixo para usar o /MV");
SetPlayerVirtualWorld(playerid,GetVehicleVirtualWorld(veiculo[playerid]));
PutPlayerInVehicle(playerid,veiculo[playerid],0);
SetPlayerVirtualWorld(playerid, GetVehicleVirtualWorld(veiculo[playerid]));

SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Veículo recuperado!");return 1;}

forward ResetX1(playerid);
public ResetX1(playerid){
X1 = 0;
X1W = 0;
X1CLOSED = 0;
X1WCLOSED = 0;
SendClientMessage(playerid,COLOUR_BRANCO,"X1 aparentemente consertado!");
}


stock ShowReisForPlayer(playerid,dialogid)
{
new MaxScore = -1,MaxScoreID = -1,MaxScoreName[MAX_PLAYER_NAME],MaxScoreInfo[MAX_PLAYER_NAME+60];
new MaxGrana = -1,MaxGranaID = -1,MaxGranaName[MAX_PLAYER_NAME],MaxGranaInfo[MAX_PLAYER_NAME+60];
new MaxSpree = -1,MaxSpreeID = -1,MaxSpreeName[MAX_PLAYER_NAME],MaxSpreeInfo[MAX_PLAYER_NAME+60];
new MaxScoreNS = -1,MaxScoreNSID = -1,MaxScoreNSName[MAX_PLAYER_NAME],MaxScoreNSInfo[MAX_PLAYER_NAME+60];

for(new i; i < GetMaxPlayers(); i++)
{
	if(IsPlayerConnected(i))
	{
	if(GetPlayerScore(i) > MaxScore){MaxScore = GetPlayerScore(i);MaxScoreID = i;}
	if(CallRemoteFunction("GetPlayerCash", "i", i) > MaxGrana){MaxGrana = CallRemoteFunction("GetPlayerCash", "i", i);MaxGranaID = i;}
	if(Spree[i] > MaxSpree){MaxSpree = Spree[i];MaxSpreeID = i;}
	if(ScoreNaSessao[i] > MaxScoreNS){MaxScoreNS = ScoreNaSessao[i];MaxScoreNSID = i;}
	}
}

GetPlayerName(MaxScoreID, MaxScoreName, MAX_PLAYER_NAME);
GetPlayerName(MaxGranaID, MaxGranaName, MAX_PLAYER_NAME);
GetPlayerName(MaxSpreeID, MaxSpreeName, MAX_PLAYER_NAME);
GetPlayerName(MaxScoreNSID, MaxScoreNSName, MAX_PLAYER_NAME);

format(MaxScoreInfo, sizeof(MaxScoreInfo), "{FFFFFF}Rei do score:{00FF00}\t%s (%i) {FF5A00} - %i", MaxScoreName,MaxScoreID,MaxScore);
format(MaxGranaInfo, sizeof(MaxGranaInfo), "{FFFFFF}Rei da grana:{00FF00}\t%s (%i) {FF5A00} - $%i", MaxGranaName,MaxGranaID,MaxGrana);
format(MaxSpreeInfo, sizeof(MaxSpreeInfo), "{FFFFFF}Rei do spree:{00FF00}\t%s (%i) {FF5A00} - %i", MaxSpreeName,MaxSpreeID,MaxSpree);
format(MaxScoreNSInfo, sizeof(MaxScoreNSInfo), "{FFFFFF}Rei dos kills:{00FF00}\t%s (%i) {FF5A00} - %i kills", MaxScoreNSName,MaxScoreNSID,MaxScoreNS);

new DialogString[650];
format(DialogString, sizeof(DialogString), "{FFFFFF}Lista dos melhores do servidor:\n\n%s\n%s\n%s\n%s\n\n{FFFF00}Para ver os rankings: /RANK\n\nEsta lista exibe somente quem está online\nA contagem de kills é somente por login",MaxScoreNSInfo,MaxScoreInfo,MaxSpreeInfo,MaxGranaInfo);
ShowPlayerDialog(playerid,dialogid,DIALOG_STYLE_MSGBOX,"Os melhores online",DialogString,"OK","Voltar");
return 1;}

stock AtualizarPlayersOnline()
{
	new string[80];
	format(string, sizeof(string), "~r~~h~~h~Players: ~w~%i ~r~~h~~h~/~w~%i", ConnectedPlayers(),GetMaxPlayers());
	TextDrawSetString(Textdraw10, string);
	return 1;
}


stock AtualizarRelogio()
{
        new string[80],hours,minutes,seconds;
        gettime(hours, minutes, seconds);
        format(string, sizeof string, "~r~~h~~h~~h~%s%d~w~:~r~~h~~h~~h~%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes);
        TextDrawSetString(Textdraw3, string);
        return 1;
}

stock GetPositionHash(playerid)
{
		new Float:ppx, Float:ppy, Float:ppz;
		GetPlayerPos(playerid, ppx, ppy, ppz);
        return floatround(ppx * ppy * ppz / 3);
}

stock ResetAwayStatus(playerid)
{
LastPosHash[playerid] = LastPosHash[playerid] + 900;
}


stock CheckPlayerAway(playerid)
{
	if(AwaySeconds[playerid] >= SvFullValueMinutes*60)
	{
		if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2)
 		{
   		new strkw[100];
		format(strkw, sizeof(strkw), "Inativo há mais de %i minutos com o servidor cheio", SvFullValueMinutes);
		CallRemoteFunction("KickPlayerEx","is",playerid,strkw);
		}
	}
}

forward TimerPorSegundo();
public TimerPorSegundo()
{
		TickCounter++;
		AtualizarRelogio();
		//HorasParaScore(playerid);
		AtualizarPlayersOnline();
		if (AntiWeapon == 1){Weaponcheck();} //ANTI WEAPON HACK
        for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){

        //Detector de Crasher Hack
        if(PreDefStateChanges[i] - L_PreDefStateChanges[i] >= 4){
        new str_hack[128],pnamehack[MAX_PLAYER_NAME];
		GetPlayerName(i, pnamehack, sizeof(pnamehack));
	    format(str_hack, sizeof(str_hack), "[ADM]: Tentativa de CRASH bloqueada: %s (%i) - [BANIDO]", pnamehack, i);
	    CallRemoteFunction("MessageToAdmins","is",COLOUR_AVISO,str_hack);
		BanEx(i, "Tentou CRASHAR players");
        PreDefStateChanges[i] = 0;}
		L_PreDefStateChanges[i] = PreDefStateChanges[i];

        //Detector de velocidade
        if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
	    {
    		if(StuntSuperSpeed[i] == false)
	        {
	            if(SpeedHack[i] == false)
	            {
	        		if(GetPlayerSpeed2D(i,true) > 290)
	        		{
	        			if(CallRemoteFunction("GetPlayerAdminLevel","i",i) < 1)
	        			{
	        			new str_speed[200],pnamespeed[MAX_PLAYER_NAME];
						GetPlayerName(i, pnamespeed, sizeof(pnamespeed));
	       	   			format(str_speed, sizeof(str_speed), "[ADM]: Possível Speed-Hack: {FFFF00}Velocidade: {00FFFF}%i KM/h {FFFF00}  Player: {00FFFF}%s (%i)", GetPlayerSpeed2D(i,true), pnamespeed, i);
	        			CallRemoteFunction("MessageToAdmins","is",COLOUR_AVISO,str_speed);
	        			SpeedHack[i] = true;
	        			}
            		}
            	}
       	  	}
	    }

		//Bane Hack de puxar vários veículos
		if(VChanges[i] - LastVChanges[i] > 2)
		{
  		new str_hack2[128],pnamehack2[MAX_PLAYER_NAME];
		GetPlayerName(i, pnamehack2, sizeof(pnamehack2));
	    format(str_hack2, sizeof(str_hack2), "[ADM]: Cheater de puxar vários veículos detectado: %s (%i) - [BANIDO]", pnamehack2, i);
	    CallRemoteFunction("MessageToAdmins","is",COLOUR_AVISO,str_hack2);
		BanEx(i, "Tentou PUXAR varios veiculos");
		OrganizarVeiculos();
		}LastVChanges[i] = VChanges[i];

	    //Monitores
	    if(Mecanica[i] == true) ExibirMecanica(i);
	    if(Altimetro[i] == true) ExibirAltimetro(i);

	    //Detectar e Kickar players Aways SVFull
	    if(ConnectedPlayers() >= SvFullValue) CheckPlayerAway(i);

        //Detector de Aways...
        if(LastPosHash[i] == GetPositionHash(i))
		AwaySeconds[i]++;
		else
		AwaySeconds[i] = 0;
		LastPosHash[i] = GetPositionHash(i);

        //Dar grana perto do Ammu LV
        if(GranaFacilValor > 0)
        {
        	if(GetPlayerState(i) == PLAYER_STATE_ONFOOT)
        	{
				if(GetPlayerVirtualWorld(i) == 0)
				{
					if(IsPlayerInRangeOfPoint(i, 20.0, 2177.0662,914.4052,10.8203))
					{
					new Float:ppx, Float:ppy, Float:ppz, Float:ppp;
					GetPlayerPos(i, ppx, ppy, ppz);
					ppp = ppx + ppy + ppz;
					if(ppp != LastDarGranaPos[i]) CallRemoteFunction("GivePlayerCash", "ii", i, GranaFacilValor);
					LastDarGranaPos[i] = ppp;
					}
				}
     		}
   		}

        //ANTI-AMMU ARENAS
        if(Arena[i] == 1)
        {
        if(ArenaTipo[i] == 7 && GetPlayerInterior(i) != 0){SetPlayerHealth(i,0.0);} //SNP
        if(ArenaTipo[i] == 10 && GetPlayerInterior(i) != 0){SetPlayerHealth(i,0.0);} //SSS
        }

		AtualizarTextoHead(i);
		UpdateTxDStatus(i);

		//DISTANCIA MISSÃO
		if(VPlayerMissao[i] != 0){
		DistanciaMis2[i] = DistanciaAtePonto(i, VMissaoPosX[i],VMissaoPosY[i],VMissaoPosZ[i]);
		if(DistanciaMis[i]-DistanciaMis2[i] > 200)	{
		if(CallRemoteFunction("GetPlayerAdminLevel","i",i) < 1){
		new dbg15[100],pname[30];
		GetPlayerName(i, pname, sizeof(pname));
		format(dbg15, sizeof(dbg15), "[ADM]: Possível Teleport/Speed Hack: /lspec %i - %s de %s",i,pname,VMissaoString[i]);
        CallRemoteFunction("MessageToAdmins","is",COLOUR_AVISO,dbg15);
        CallRemoteFunction("SaveToFile","ss","MissoesHack",dbg15);
        if(VPlayerMissao[i] != 0){
		DisablePlayerCheckpoint(i);
		VPlayerMissao[i] = 0;
		SendClientMessage(i, COLOUR_AVISO, "[AVISO]: Missão fracassada! (Suspeita de teleporte)");
		GameTextForPlayer(i,"~n~~n~~n~~n~~n~~n~~r~MISSAO FRACASSADA!", 5000, 5);}

		}else{
		new dbg1[100];
		format(dbg1, sizeof(dbg1), "Anti-Cheat Debug: %i metros (era pra ser menos de 100 metros)",DistanciaMis[i]-DistanciaMis2[i]);
		CallRemoteFunction("SaveToFile","ss","Debug",dbg1);
		SendClientMessage(i, COLOUR_AVISO,dbg1);}}

		VMissaoTick[i]++;
		DistanciaMis[i] = DistanciaAtePonto(i, VMissaoPosX[i],VMissaoPosY[i],VMissaoPosZ[i]);
		if(VMissaoTick[i] >= 5){
		new misstring[100];
		format(misstring, sizeof(misstring), "~n~~n~~n~~n~~n~~n~~y~%s~n~~b~Distancia: ~w~%i ~b~Metros",VMissaoString[i],DistanciaMis[i]);
		GameTextForPlayer(i,misstring, 5000, 5);}}

        //Auto-Kick ESC X1 X1W
		if(Arena[i] == 1) if(ArenaTipo[i] == 3 || ArenaTipo[i] == 8)
		{
		if(AwaySeconds[i] >= 40) SendClientMessage(i, COLOUR_AVISO, "[AVISO]: Não fique parado aqui. Você poderá ser kickado. Mexa-se!");
        if(AwaySeconds[i] >= 60) CallRemoteFunction("KickPlayerEx","is",i,"Inativo no X1 ou X1W");
        }

        if(EAM_Player[i]==true && EAM_Checkpoint[i] == true && EAM_EmProgresso == 1){
            if(AwaySeconds[i] > 20 && AwaySeconds[i] < 39){
                SendClientMessage(i, COLOUR_AVISO, "[AVISO]: Não fique parado ou de esc no EAM!");
			}
			if(AwaySeconds[i] >= 40){
				EAM_Checkpoint[i] = false;
				EAM_ESC[i] = true;
				EventoProibirTeleEAM[i] = false;
				SetPlayerHealth(i, 0.0);
				SendClientMessage(i, COLOUR_ERRO, "[AVISO - EAM]: Voce não esta mais participando pois ficou muito tempo AFK!!");
   			}
		}

        //ULTRAGC
  		if(UltraGC[i] == 1){
		if(GetPlayerState(i) == PLAYER_STATE_DRIVER){
		SetPlayerHealth(i,100000);
		RepairVehicle(GetPlayerVehicleID(i));
		SetVehicleHealth(GetPlayerVehicleID(i),10000.0);}}

		//MENSAGEM PRISÃO
		//if(preso[i] == 1){GameTextForPlayer(i,cadeiastring,2000,3);}

            if(GodCarOn[i] == 1)
            {
     			if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
       			{
       			                //VEÍCULOS COM GOD DESABILITADO
								switch(GetVehicleModel( GetPlayerVehicleID(i) )) {
								case 592,577,511,512,593,520,553,476,519,460,513,548,
								425,417,487,488,497,563,447,469,472,473,493,595,484,
								430,453,452,446,454,441,464,465,501,564,594,432,601:continue;}
								if(VPlayerMissao[i] == 0){RepairVehicle(GetPlayerVehicleID(i));}

                }

			}

        }
   }
}


public AutoGodConnect(playerid)
{
if (GodCarOn[playerid] != 1)
{GodCarOn[playerid] = 1;
SendClientMessage(playerid, COLOUR_AVISO, "É PROIBIDO ATIRAR DE DENTRO DE CARRO INVULNERAVEL");
SendClientMessage(playerid, COLOUR_AVISO, "PARA DESABILITAR O GODCAR USE: /GC");}
return 1;
}

stock GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
	new Float:a;
	GetPlayerPos(playerid, x, y, a);

	if(GetPlayerVehicleID(playerid)) { GetVehicleZAngle(GetPlayerVehicleID(playerid), a); }

	GetPlayerFacingAngle(playerid, a);
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}


stock ExibirAltimetro(playerid)
{
	if(IsPlayerSpawned(playerid))
	{
	new Float:AltX,Float:AltY,Float:AltZ;
	new AltimetroString[100];
	 if(IsPlayerInAnyVehicle(playerid))
	 GetVehiclePos(GetPlayerVehicleID(playerid), AltX, AltY, AltZ);
	 else
	 GetPlayerPos(playerid, AltX, AltY, AltZ);
	format(AltimetroString, sizeof(AltimetroString), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~~w~%.0f ~r~metros", AltZ);
	GameTextForPlayer(playerid, AltimetroString, 3000, 3);
	}
}


stock ExibirMecanica(playerid)
{
	if(IsPlayerInAnyVehicle(playerid))
	{
	new mecstr[100],vehstate[22];
	new Float:health;
	GetVehicleHealth(GetPlayerVehicleID(playerid), health);
	if(health > 0)    vehstate = "~r~FALHA MECANICA";
	if(health > 250)  vehstate = "~r~I";
	if(health > 300)  vehstate = "~r~II";
	if(health > 350)  vehstate = "~r~III";
	if(health > 400)  vehstate = "~r~IIII";
	if(health > 450)  vehstate = "~r~IIIII";
	if(health > 500)  vehstate = "~y~IIIIII";
	if(health > 550)  vehstate = "~y~IIIIIII";
	if(health > 600)  vehstate = "~y~IIIIIIII";
	if(health > 650)  vehstate = "~y~IIIIIIIII";
	if(health > 700)  vehstate = "~y~IIIIIIIIII";
	if(health > 750)  vehstate = "~y~IIIIIIIIIII";
	if(health > 800)  vehstate = "~g~IIIIIIIIIIII";
	if(health > 850)  vehstate = "~g~IIIIIIIIIIIII";
	if(health > 900)  vehstate = "~g~IIIIIIIIIIIIII";
	if(health > 950)  vehstate = "~g~IIIIIIIIIIIIIII";
	if(health > 1000) vehstate = "~b~IIIIIIIIIIIIIII";
	format(mecstr, sizeof(mecstr), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~~w~%s", vehstate);
	GameTextForPlayer(playerid, mecstr, 3000, 3);
	}
}


stock MostrarListaCompras(playerid){
SendClientMessage(playerid, COLOUR_DICA, "");
SendClientMessage(playerid, COLOUR_DICA, "KIT ARMAS RUN > $20000 > /kitrun");
SendClientMessage(playerid, COLOUR_DICA, "KIT ARMAS WALK > $20000 > /kitwalk");
SendClientMessage(playerid, COLOUR_DICA, "KIT ARMAS TOP > $30000 > /kittop");
SendClientMessage(playerid, COLOUR_DICA, "KIT 200 GRANADAS > $50000 > /kitgranadas");
//SendClientMessage(playerid, COLOUR_DICA, "KIT 200 MOLOTOVS > $200000 > /kitmolotovs");
SendClientMessage(playerid, COLOUR_DICA, "KIT 200 TEAR GAS > $50000 > /kitgas");
SendClientMessage(playerid, COLOUR_DICA, "KIT GAY > $24 > /kitgay");
//SendClientMessage(playerid, COLOUR_DICA, "KIT 3 ROJÕES > $15000 > /kitrojoes");
SendClientMessage(playerid, COLOUR_DICA, "");
return 1;}

forward spawn(playerid);
public spawn(playerid){
TogglePlayerSpectating(playerid, 0);
SpawnPlayer(playerid);}

public OnVehicleSpawn(vehicleid)
{
if(vehicleid < UltimoVeiculoGM){AutoTune(vehicleid);} //RETUNAR

if(vehicleid == PVC_VeiculosObjetosCarro[0]){SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[0], 225);}
if(vehicleid == PVC_VeiculosObjetosCarro[1]){SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[1], 225);}
if(vehicleid == PVC_VeiculosObjetosCarro[2]){SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[2], 225);}
if(vehicleid == PVC_VeiculosObjetosCarro[3]){SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[3], 225);}
if(vehicleid == PVC_VeiculosObjetosCarro[4]){SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[4], 225);}
if(vehicleid == PVC_VeiculosObjetosCarro[5]){SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[5], 225);}
if(vehicleid == PVC_VeiculosObjetosCarro[6]){SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[6], 225);}
if(vehicleid == PVC_VeiculosObjetosCarro[7]){SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[7], 225);}
if(vehicleid == PVC_VeiculosObjetosCarro[8]){SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[8], 225);}
if(vehicleid == PVC_VeiculosObjetosCarro[9]){SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[9], 225);}
if(vehicleid == PVC_VeiculosObjetosCarro[10]){SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[10], 225);}
if(vehicleid == PVC_VeiculosObjetosCarro[11]){SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[11], 225);}
if(vehicleid == PVC_VeiculosObjetosCarro[12]){SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[12], 225);}
if(vehicleid == PVC_VeiculosObjetosCarro[13]){SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[13], 225);}
if(vehicleid == PVC_VeiculosObjetosCarro[14]){SetVehicleVirtualWorld(PVC_VeiculosObjetosCarro[14], 225);}

if(vehicleid == PVC_VeiculosObjetosMoto[0]){SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[0], 224);}
if(vehicleid == PVC_VeiculosObjetosMoto[1]){SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[1], 224);}
if(vehicleid == PVC_VeiculosObjetosMoto[2]){SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[2], 224);}
if(vehicleid == PVC_VeiculosObjetosMoto[3]){SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[3], 224);}
if(vehicleid == PVC_VeiculosObjetosMoto[4]){SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[4], 224);}
if(vehicleid == PVC_VeiculosObjetosMoto[5]){SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[5], 224);}
if(vehicleid == PVC_VeiculosObjetosMoto[6]){SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[6], 224);}
if(vehicleid == PVC_VeiculosObjetosMoto[7]){SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[7], 224);}
if(vehicleid == PVC_VeiculosObjetosMoto[8]){SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[8], 224);}
if(vehicleid == PVC_VeiculosObjetosMoto[9]){SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[9], 224);}
if(vehicleid == PVC_VeiculosObjetosMoto[10]){SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[10], 224);}
if(vehicleid == PVC_VeiculosObjetosMoto[11]){SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[11], 224);}
if(vehicleid == PVC_VeiculosObjetosMoto[12]){SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[12], 224);}
if(vehicleid == PVC_VeiculosObjetosMoto[13]){SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[13], 224);}
if(vehicleid == PVC_VeiculosObjetosMoto[14]){SetVehicleVirtualWorld(PVC_VeiculosObjetosMoto[14], 224);}

if(vehicleid == PL_Veiculos[0]){SetVehicleVirtualWorld(PL_Veiculos[0], 2626);}
if(vehicleid == PL_Veiculos[1]){SetVehicleVirtualWorld(PL_Veiculos[1], 2626);}
if(vehicleid == PL_Veiculos[2]){SetVehicleVirtualWorld(PL_Veiculos[2], 2626);}
if(vehicleid == PL_Veiculos[3]){SetVehicleVirtualWorld(PL_Veiculos[3], 2626);}
if(vehicleid == PL_Veiculos[4]){SetVehicleVirtualWorld(PL_Veiculos[4], 2626);}
if(vehicleid == PL_Veiculos[5]){SetVehicleVirtualWorld(PL_Veiculos[5], 2626);}
if(vehicleid == PL_Veiculos[6]){SetVehicleVirtualWorld(PL_Veiculos[6], 2626);}
if(vehicleid == PL_Veiculos[7]){SetVehicleVirtualWorld(PL_Veiculos[7], 2626);}
if(vehicleid == PL_Veiculos[8]){SetVehicleVirtualWorld(PL_Veiculos[8], 2626);}
if(vehicleid == PL_Veiculos[9]){SetVehicleVirtualWorld(PL_Veiculos[9], 2626);}
if(vehicleid == PL_Veiculos[10]){SetVehicleVirtualWorld(PL_Veiculos[10], 2626);}
if(vehicleid == PL_Veiculos[11]){SetVehicleVirtualWorld(PL_Veiculos[11], 2626);}
if(vehicleid == PL_Veiculos[12]){SetVehicleVirtualWorld(PL_Veiculos[12], 2626);}
if(vehicleid == PL_Veiculos[13]){SetVehicleVirtualWorld(PL_Veiculos[13], 2626);}
if(vehicleid == PL_Veiculos[14]){SetVehicleVirtualWorld(PL_Veiculos[14], 2626);}
if(vehicleid == PL_Veiculos[15]){SetVehicleVirtualWorld(PL_Veiculos[15], 2626);}
if(vehicleid == PL_Veiculos[16]){SetVehicleVirtualWorld(PL_Veiculos[16], 2626);}
if(vehicleid == PL_Veiculos[17]){SetVehicleVirtualWorld(PL_Veiculos[17], 2626);}
if(vehicleid == PL_Veiculos[18]){SetVehicleVirtualWorld(PL_Veiculos[18], 2626);}
if(vehicleid == PL_Veiculos[19]){SetVehicleVirtualWorld(PL_Veiculos[19], 2626);}
if(vehicleid == PL_Veiculos[20]){SetVehicleVirtualWorld(PL_Veiculos[20], 2626);}
if(vehicleid == PL_Veiculos[21]){SetVehicleVirtualWorld(PL_Veiculos[21], 2626);}
if(vehicleid == PL_Veiculos[22]){SetVehicleVirtualWorld(PL_Veiculos[22], 2626);}
if(vehicleid == PL_Veiculos[22]){SetVehicleVirtualWorld(PL_Veiculos[23], 2626);}
if(vehicleid == PL_Veiculos[22]){SetVehicleVirtualWorld(PL_Veiculos[24], 2626);}
if(vehicleid == PL_Veiculos[22]){SetVehicleVirtualWorld(PL_Veiculos[25], 2626);}
if(vehicleid == PL_Veiculos[22]){SetVehicleVirtualWorld(PL_Veiculos[26], 2626);}
if(vehicleid == PL_Veiculos[22]){SetVehicleVirtualWorld(PL_Veiculos[27], 2626);}
if(vehicleid == PL_Veiculos[22]){SetVehicleVirtualWorld(PL_Veiculos[28], 2626);}
if(vehicleid == PL_Veiculos[22]){SetVehicleVirtualWorld(PL_Veiculos[29], 2626);}

if(vehicleid == SURFAEROLS){SetVehicleVirtualWorld(SURFAEROLS, 1000);}
if(vehicleid == NV[0]){SetVehicleVirtualWorld(NV[0], 18);}
if(vehicleid == NV[1]){SetVehicleVirtualWorld(NV[1], 18);}
if(vehicleid == NV[2]){SetVehicleVirtualWorld(NV[2], 18);}
if(vehicleid == NV[3]){SetVehicleVirtualWorld(NV[3], 18);}
if(vehicleid == NV[4]){SetVehicleVirtualWorld(NV[4], 18);}
if(vehicleid == NV[5]){SetVehicleVirtualWorld(NV[5], 18);}
if(vehicleid == NV[6]){SetVehicleVirtualWorld(NV[6], 18);}
if(vehicleid == NV[7]){SetVehicleVirtualWorld(NV[7], 18);}
if(vehicleid == NV[8]){SetVehicleVirtualWorld(NV[8], 18);}
if(vehicleid == NV[9]){SetVehicleVirtualWorld(NV[9], 18);}
if(vehicleid == NV[10]){SetVehicleVirtualWorld(NV[10], 18);}
if(vehicleid == NV[11]){SetVehicleVirtualWorld(NV[11], 18);}
if(vehicleid == NV[12]){SetVehicleVirtualWorld(NV[12], 18);}
if(vehicleid == NV[13]){SetVehicleVirtualWorld(NV[13], 18);}
if(vehicleid == NV[14]){SetVehicleVirtualWorld(NV[14], 18);}
if(vehicleid == NV[15]){SetVehicleVirtualWorld(NV[15], 18);}
if(vehicleid == NV[16]){SetVehicleVirtualWorld(NV[16], 18);}
if(vehicleid == NV[17]){SetVehicleVirtualWorld(NV[17], 18);}
if(vehicleid == NV[18]){SetVehicleVirtualWorld(NV[18], 18);}
if(vehicleid == NV[19]){SetVehicleVirtualWorld(NV[19], 18);}
if(vehicleid == NV[20]){SetVehicleVirtualWorld(NV[20], 18);}
if(vehicleid == NV[21]){SetVehicleVirtualWorld(NV[21], 18);}
if(vehicleid == NV[22]){SetVehicleVirtualWorld(NV[22], 18);}
if(vehicleid == NV[23]){SetVehicleVirtualWorld(NV[23], 18);}
if(vehicleid == NV[24]){SetVehicleVirtualWorld(NV[24], 18);}
if(vehicleid == NV[25]){SetVehicleVirtualWorld(NV[25], 18);}
if(vehicleid == NV[26]){SetVehicleVirtualWorld(NV[26], 18);}
if(vehicleid == NV[27]){SetVehicleVirtualWorld(NV[27], 18);}
if(vehicleid == NV[28]){SetVehicleVirtualWorld(NV[28], 18);}
if(vehicleid == NV[29]){SetVehicleVirtualWorld(NV[29], 18);}
if(vehicleid == NV[30]){SetVehicleVirtualWorld(NV[30], 18);}
if(vehicleid == NV[31]){SetVehicleVirtualWorld(NV[31], 18);}
if(vehicleid == NV[32]){SetVehicleVirtualWorld(NV[32], 18);}
if(vehicleid == NV[33]){SetVehicleVirtualWorld(NV[33], 18);}
if(vehicleid == NV[34]){SetVehicleVirtualWorld(NV[34], 18);}
if(vehicleid == NV[35]){SetVehicleVirtualWorld(NV[35], 18);}

if(vehicleid == SSSArena[0]){SetVehicleVirtualWorld(SSSArena[0], 21);}
if(vehicleid == SSSArena[1]){SetVehicleVirtualWorld(SSSArena[1], 21);}
if(vehicleid == SSSArena[2]){SetVehicleVirtualWorld(SSSArena[2], 21);}
if(vehicleid == SSSArena[3]){SetVehicleVirtualWorld(SSSArena[3], 21);}
if(vehicleid == SSSArena[4]){SetVehicleVirtualWorld(SSSArena[4], 21);}
if(vehicleid == SSSArena[5]){SetVehicleVirtualWorld(SSSArena[5], 21);}
if(vehicleid == SSSArena[6]){SetVehicleVirtualWorld(SSSArena[6], 21);}
if(vehicleid == SSSArena[7]){SetVehicleVirtualWorld(SSSArena[7], 21);}
if(vehicleid == SSSArena[8]){SetVehicleVirtualWorld(SSSArena[8], 21);}
if(vehicleid == SSSArena[9]){SetVehicleVirtualWorld(SSSArena[9], 21);}
if(vehicleid == SSSArena[10]){SetVehicleVirtualWorld(SSSArena[10], 21);}
if(vehicleid == SSSArena[11]){SetVehicleVirtualWorld(SSSArena[11], 21);}
if(vehicleid == SSSArena[12]){SetVehicleVirtualWorld(SSSArena[12], 21);}
if(vehicleid == SSSArena[13]){SetVehicleVirtualWorld(SSSArena[13], 21);}
if(vehicleid == SSSArena[14]){SetVehicleVirtualWorld(SSSArena[14], 21);}
if(vehicleid == SSSArena[15]){SetVehicleVirtualWorld(SSSArena[15], 21);}
if(vehicleid == SSSArena[16]){SetVehicleVirtualWorld(SSSArena[16], 21);}
if(vehicleid == SSSArena[17]){SetVehicleVirtualWorld(SSSArena[17], 21);}
if(vehicleid == SSSArena[18]){SetVehicleVirtualWorld(SSSArena[18], 21);}
if(vehicleid == SSSArena[19]){SetVehicleVirtualWorld(SSSArena[19], 21);}




if(vehicleid == HydraGM){SetVehicleVirtualWorld(HydraGM, 0);}
if(vehicleid == SeaspGM){SetVehicleVirtualWorld(SeaspGM, 0);}




//DESTRUIR VEÍCULOS DE EVENTO AO EXPLODIREM
for(new i; i < GetMaxPlayers(); i++){
if(vehicleid==EventoVeiculo[i]){
DestroyVehicle(EventoVeiculo[i]);
EventoVeiculo[i] = 0;}}

return 1;
}



stock SendClientMessageToAllEx(exeption, color, const message[])
{
 for(new i; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(i != exeption)
		    {
		        SendClientMessage(i, color, message);
			}
		}
	}
}


stock ChecarVeiculosProibidosParaTele(playerid){
switch(GetVehicleModel( GetPlayerVehicleID(playerid) )) {
case 592,577,511,512,593,520,553,476,519,460,513,548,
425,417,487,488,497,563,447,469,472,473,493,595,484,
430,453,452,446,454,441,464,465,501,564,594,432,449,538,590:return 1;}
return 0;}

forward GetTickCounterGM(playerid);
public GetTickCounterGM(playerid){return TickCounter;}

// ---------------------- SALVAR NA CONTA ----------------------------------------------
forward GetSkinStatus(playerid);
public GetSkinStatus(playerid){return skin[playerid];}

forward GetPlayerAwaySeconds(playerid);
public GetPlayerAwaySeconds(playerid){return AwaySeconds[playerid];}

forward GetColorStatus(playerid);
public GetColorStatus(playerid){return cor[playerid];}

forward GetPlayerVehicleSpawned(playerid);
public GetPlayerVehicleSpawned(playerid){return veiculo[playerid];}

forward GetPlayerArenaStatus(playerid);
public GetPlayerArenaStatus(playerid){return Arena[playerid];}

forward GetPlayerArenaStatus2(playerid);
public GetPlayerArenaStatus2(playerid){return Arena2[playerid];}

forward GetPlayerPresoStatus(playerid);
public GetPlayerPresoStatus(playerid){return preso[playerid];}

forward  GetHappyHourStatus(playerid);
public GetHappyHourStatus(playerid){return HappyHour;}

forward GetEventoAtivoStatus(playerid);
public GetEventoAtivoStatus(playerid){return EventoAtivo;}

forward GetPlayerArenaTipoStatus(playerid);
public GetPlayerArenaTipoStatus(playerid){return ArenaTipo[playerid];}

forward GetPlayerGCStatus(playerid);
public GetPlayerGCStatus(playerid){return GodCarOn[playerid];}

forward GetPlayerSpreeStatus(playerid);
public GetPlayerSpreeStatus(playerid){return Spree[playerid];}

forward GetPlayerTrancarStatus(playerid);
public GetPlayerTrancarStatus(playerid){return AutoTrancar[playerid];}

forward GetPCSStatus(playerid);
public GetPCSStatus(playerid){return PlayerCustomSpawn[playerid];}

forward GetPCSStatus_I(playerid);
public GetPCSStatus_I(playerid){return PlayerCustomSpawn_I[playerid];}

forward GetPCSStatus_X(playerid);
public GetPCSStatus_X(playerid){return floatround(PlayerCustomSpawn_X[playerid]);}

forward GetPCSStatus_Y(playerid);
public GetPCSStatus_Y(playerid){return floatround(PlayerCustomSpawn_Y[playerid]);}

forward GetPCSStatus_Z(playerid);
public GetPCSStatus_Z(playerid){return floatround(PlayerCustomSpawn_Z[playerid]);}

forward GetPCSStatus_F(playerid);
public GetPCSStatus_F(playerid){return floatround(PlayerCustomSpawn_F[playerid]);}

forward GetRojoesStatus(playerid);
public GetRojoesStatus(playerid){return Rojoes[playerid];}
// -------------------------------------------------------------------------------------


forward CriarVeiculoParaPlayerNaMarra(playerid, modelo);
public CriarVeiculoParaPlayerNaMarra(playerid, modelo){
if(modelo < 400 || modelo > 611) return 1;
if(!IsPlayerConnected(playerid)) return 1;
if(!IsPlayerSpawned(playerid)) return 1;
DestroyNeons(playerid,false);
if(veiculo[playerid] != 0){DestroyVehicle(veiculo[playerid]);vtrancado[veiculo[playerid]] = 0;veiculo[playerid] = 0;}
new Float:X,Float:Y,Float:Z,Float:Angle;GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
veiculo[playerid] = CreateVehicle(modelo,X,Y,Z+5,Angle,PVA(),PVA(),-1);
AddVehicleComponent(veiculo[playerid], 1010);
SetVehicleVirtualWorld(veiculo[playerid], GetPlayerVirtualWorld(playerid));
LinkVehicleToInterior(veiculo[playerid], GetPlayerInterior(playerid));
PutPlayerInVehicle(playerid,veiculo[playerid],0);
if(AutoTrancar[playerid] == 1){
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){
if(i != playerid){SetVehicleParamsForPlayer(veiculo[playerid],i, 0, 1);}}}
vtrancado[veiculo[playerid]] = 1;}
OcultarDonoDoVeiculo(playerid);
return 1;}



forward CriarVeiculodeEventoParaPlayer(playerid, modelo);
public CriarVeiculodeEventoParaPlayer(playerid, modelo){
if(!IsPlayerConnected(playerid)) return 1;
if(!IsPlayerSpawned(playerid)) return 1;
if(EventoVeiculo[playerid] != 0){DestroyVehicle(EventoVeiculo[playerid]);EventoVeiculo[playerid] = 0;}
new Float:X,Float:Y,Float:Z,Float:Angle;GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
EventoVeiculo[playerid] = CreateVehicle(modelo,X,Y,Z+5,Angle,PVA(),PVA(),-1);
AddVehicleComponent(EventoVeiculo[playerid], 1010);
SetVehicleVirtualWorld(EventoVeiculo[playerid], GetPlayerVirtualWorld(playerid));
LinkVehicleToInterior(EventoVeiculo[playerid], GetPlayerInterior(playerid));
PutPlayerInVehicle(playerid,EventoVeiculo[playerid],0);
return 1;}


forward CriarVeiculoParaPlayer(playerid, modelo);
public CriarVeiculoParaPlayer(playerid, modelo){
if(!IsPlayerSpawned(playerid)){return 1;}
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) return 1;
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(Arena2[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);

if(GetPlayerInterior(playerid) != 0){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2){
SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está dentro de um interior.");return 1;}}

if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2){
if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está em uma área não permitida para veículos.");}
//CHECAR LOCAL
if(CallRemoteFunction("LocalInvalidoParaCS","i",playerid) == 1){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2){
SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Proibido criar veículos neste local");return 1;}}

//AVIOES GRANDES E APELOES
if(!IsPlayerInRangeOfPoint(playerid, 300.0, 426.5363,2499.9019,16.4844))
{
	if(modelo == 592 || modelo == 577 || modelo == 476)
	{
	SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Este avião só pode ser criado em: /AEROAB");
	return 1;
	}
}

//BUGGERS ANDROMADA
if(modelo == 592){new SACSB[100];
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(SACSB, sizeof(SACSB), "[ADM]: %s (%i) fez um ANDROMADA", pname, playerid);
CallRemoteFunction("MessageToAdmins","is",COLOUR_AVISO,SACSB);}
//BUGGERS AT-400
if(modelo == 577){new SACSB[100];
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(SACSB, sizeof(SACSB), "[ADM]: %s (%i) fez um AT-400", pname, playerid);
CallRemoteFunction("MessageToAdmins","is",COLOUR_AVISO,SACSB);}
//BUGGERS REEFER
if(modelo == 453){new SACSB[100];
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(SACSB, sizeof(SACSB), "[ADM]: %s (%i) fez um REEFER", pname, playerid);
CallRemoteFunction("MessageToAdmins","is",COLOUR_AVISO,SACSB);}
//BUGGERS TROPIC
if(modelo == 454){new SACSB[100];
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(SACSB, sizeof(SACSB), "[ADM]: %s (%i) fez um TROPIC", pname, playerid);
CallRemoteFunction("MessageToAdmins","is",COLOUR_AVISO,SACSB);}
//ANTIBUG
if(modelo == 310) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Este veículo esta indisponível no momento!");
if(modelo == 590) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Este veículo esta indisponível no momento!");
if(modelo == 449) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Este veículo esta indisponível no momento!");
if(modelo == 538) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Este veículo esta indisponível no momento!");

//CARRO DE ADMIN
//if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5){
//if(modelo == 576) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Este veículo esta indisponível no momento!");}
//CHECAR NOOB HOURS
if(HappyHour == 0){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 3){
if(modelo == 594){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Este veículo esta indisponível no momento!");} //rc globin
if(modelo == 432){return SendClientMessage(playerid, COLOUR_AVISO, "[AVISO]: Veículo disponível somente em: /MD");}
if(modelo == 520){return SendClientMessage(playerid, COLOUR_AVISO, "[AVISO]: Veículo disponível somente em: /MD");}
if(modelo == 447){return SendClientMessage(playerid, COLOUR_AVISO, "[AVISO]: Veículo disponível somente em: /MD");}
if(modelo == 425){return SendClientMessage(playerid, COLOUR_AVISO, "[AVISO]: Veículo disponível somente em: /MD");}
if(modelo == 464){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Este veículo esta indisponível no momento!");}
//if(modelo == 427){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Este veículo esta indisponível no momento!");}
//if(modelo == 416){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Este veículo esta indisponível no momento!");}
//if(modelo == 588){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Este veículo esta indisponível no momento!");}
if(modelo == 465){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Este veículo esta indisponível no momento!");}
if(modelo == 501){return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Este veículo esta indisponível no momento!");}
//if(modelo == 476){return SendClientMessage(playerid, COLOUR_AVISO, "[AVISO]: Veículo disponível somente nos aeroportos");}
}}
//ANTI-CAR RESPAWN PARA ESCAPAR DA MORTE
if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 432){if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo atual.");}
if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 520){if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo atual.");}
if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 447){if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo atual.");}
if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 425){if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo atual.");}
if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 464){if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo atual.");}
DestroyNeons(playerid,false);
if(veiculo[playerid] != 0){DestroyVehicle(veiculo[playerid]);vtrancado[veiculo[playerid]] = 0;veiculo[playerid] = 0;}
//new colour1 = random(126);
new Float:X,Float:Y,Float:Z,Float:Angle;GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
veiculo[playerid] = CreateVehicle(modelo,X,Y,Z+1,Angle,PVA(),PVA(),-1);
AddVehicleComponent(veiculo[playerid], 1010);
SetVehicleVirtualWorld(veiculo[playerid], GetPlayerVirtualWorld(playerid));
LinkVehicleToInterior(veiculo[playerid], GetPlayerInterior(playerid));
PutPlayerInVehicle(playerid,veiculo[playerid],0);
if(AutoTrancar[playerid] == 1){
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){
if(i != playerid){SetVehicleParamsForPlayer(veiculo[playerid],i, 0, 1);}}}
vtrancado[veiculo[playerid]] = 1;
}

SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Veículo fornecido!");
//GameTextForPlayer(playerid,"~y~VEICULO FORNECIDO!", 1000, 5);
return 1;}

stock OcultarDonoDoVeiculo(playerid)
{
Update3DTextLabelText(TextoVeiculo[playerid],0xFF8408FF," ");
return 1;
}

stock CriarHydraGM()
{
if(HydraGM != 0){DestroyVehicle(HydraGM);HydraGM = 0;}
HydraGM = CreateVehicle(520,2617.9673,2721.6445,37.2608,89.7657,6,32,60);
dini_IntSet("ZNS.ini","HydraGM",1);
return 1;
}

stock DestruirHydraGM()
{
if(HydraGM != 0){DestroyVehicle(HydraGM);HydraGM = 0;}
dini_IntSet("ZNS.ini","HydraGM",0);
return 1;
}

stock RespawnHydraGM()
{
if(HydraGM != 0){SetVehicleToRespawn(HydraGM);}
return 1;
}

stock DerrubarHydraGM()
{
if(HydraGM != 0){SetVehicleHealth(HydraGM,0.0);}
return 1;
}


stock CriarSeaspGM()
{
if(SeaspGM != 0){DestroyVehicle(SeaspGM);SeaspGM = 0;}
SeaspGM = CreateVehicle(447,-756.0000,-1947.0000,6.1012,164.4969,6,32,60);
dini_IntSet("ZNS.ini","SeaspGM",1);
return 1;
}

stock DestruirSeaspGM()
{
if(SeaspGM != 0){DestroyVehicle(SeaspGM);SeaspGM = 0;}
dini_IntSet("ZNS.ini","SeaspGM",0);
return 1;
}

stock RespawnSeaspGM()
{
if(SeaspGM != 0){SetVehicleToRespawn(SeaspGM);}
return 1;
}

stock DerrubarSeaspGM()
{
if(SeaspGM != 0){SetVehicleHealth(SeaspGM,0.0);}
return 1;
}

stock MostrarDonoDoVeiculo(playerid)
{
new pdname[MAX_PLAYER_NAME],carstring[60];
new Float:X,Float:Y,Float:Z;GetPlayerPos(playerid,X,Y,Z);
GetPlayerName(playerid, pdname, MAX_PLAYER_NAME);
format(carstring, sizeof(carstring), "Veículo de:\n%s [ID:%i]", pdname, playerid);
Update3DTextLabelText(TextoVeiculo[playerid],0xFF8408FF,carstring);
Attach3DTextLabelToVehicle(TextoVeiculo[playerid],veiculo[playerid],0.0,0.0,1.0);
return 1;
}



stock AtualizarTextoHead(playerid)
{
new TextoToHead[40];
if(Arena[playerid] == 1 && ArenaTipo[playerid]!=24){
format(TextoToHead,sizeof(TextoToHead),"%i ms{FFFFFF}   {00BEFF}%i FPS",GetPlayerPing(playerid),GetPlayerFPS(playerid));
Update3DTextLabelText(TextoHead[playerid],COLOUR_INFORMACAO,TextoToHead);
}else{
switch (GetPlayerWantedLevel(playerid)){
case 0: Update3DTextLabelText(TextoHead[playerid],COLOUR_ERRO," ");
case 1: Update3DTextLabelText(TextoHead[playerid],COLOUR_ERRO,"RECOMPENSA $10000");
case 2: Update3DTextLabelText(TextoHead[playerid],COLOUR_ERRO,"RECOMPENSA $20000");
case 3: Update3DTextLabelText(TextoHead[playerid],COLOUR_ERRO,"RECOMPENSA $30000");
case 4: Update3DTextLabelText(TextoHead[playerid],COLOUR_ERRO,"RECOMPENSA $40000");
case 5: Update3DTextLabelText(TextoHead[playerid],COLOUR_ERRO,"RECOMPENSA $50000");
case 6: Update3DTextLabelText(TextoHead[playerid],COLOUR_ERRO,"RECOMPENSA $60000");}}
return 1;
}

stock ResyncVeiculo(playerid)
{
if(!IsPlayerConnected(playerid)) return 1;
if(!IsPlayerSpawned(playerid)){return 1;}
if(veiculo[playerid] == 0){return 1;}
if(GetPlayerVirtualWorld(playerid) != 0){return 1;}
new Float:playerposx, Float:playerposy, Float:playerposz;
GetPlayerPos(playerid, playerposx, playerposy, playerposz);
SetPlayerPos(playerid,playerposx, playerposy, playerposz+2);
RemovePlayerFromVehicle(playerid);
SetVehicleVirtualWorld(veiculo[playerid], 999);
SetTimerEx("ResyncVeiculo2",1000,false, "i", playerid);
return 1;
}

forward ResyncVeiculo2(playerid);
public ResyncVeiculo2(playerid)
{
if(!IsPlayerConnected(playerid)) {return 1;}
if(!IsPlayerSpawned(playerid)){return 1;}
if(veiculo[playerid] == 0){return 1;}
SetVehicleVirtualWorld(veiculo[playerid], 0);
if(GetPlayerVirtualWorld(playerid) != 0){return 1;}
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(Arena2[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(GetPlayerInterior(playerid) != 0){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2){
SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está dentro de um interior.");return 1;}}
if(NoEvento[playerid] == 1 && EventoProibirCS == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você está em um evento. Para sair: /sair");
if(CallRemoteFunction("LocalInvalidoParaCS","i",playerid) == 1){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2){
SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Proibido criar veículos neste local");return 1;}}
new Float:playerposx, Float:playerposy, Float:playerposz,Float:Angle;
GetPlayerPos(playerid, playerposx, playerposy, playerposz);
SetVehicleVirtualWorld(veiculo[playerid], GetPlayerVirtualWorld(playerid));
LinkVehicleToInterior(veiculo[playerid], GetPlayerInterior(playerid));
GetPlayerFacingAngle(playerid,Angle);
SetVehicleZAngle(veiculo[playerid], Angle);
SetVehiclePos(veiculo[playerid], playerposx, playerposy, playerposz);
PutPlayerInVehicle(playerid,veiculo[playerid],0);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Veículo sincronizado!");
return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{if(vtrancado[vehicleid] == 1){
if(vehicleid != veiculo[forplayerid]){SetVehicleParamsForPlayer(vehicleid,forplayerid, 0, 1);}}}

stock MostrarMenuRanks(playerid)
{
ShowPlayerDialog(playerid,9600,DIALOG_STYLE_LIST,"Escolha o ranking desejado:","1.\tRanking de kills\n2.\tRanking de score\n3.\tRanking de spree\n4.\tRanking de dinheiro\n5.\tMelhores players online","Mostrar","Voltar");
return 1;
}

stock MostrarMenuPainel(playerid)
{
ShowPlayerDialog(playerid,989,DIALOG_STYLE_LIST,"Escolha a opção para seu veiculo:","Motor\nFarois\nAlarme\nCapo\nMala\nPlaca\nFarois piscando","Selecionar","Voltar");
return 1;
}


stock ShowTopTenScoreForPlayer(playerid)
{
new MaxData[11];
new MaxDataID[11];
new bool:OnTheRank[MAX_PLAYERS];
new DataSource[MAX_PLAYERS];
new Ranking[570];
new DialogString[1000];

for(new i; i < GetMaxPlayers(); i++)
{
	if(IsPlayerConnected(i)) DataSource[i] = GetPlayerScore(i); //FONTE DE DADOS DO RANKING
}

for(new i; i < 11; i++){MaxData[i] = -1;MaxDataID[i] = -1;} //Preparar variáveis

for(new i; i < GetMaxPlayers(); i++) // Posição 1º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[1])
		{
		MaxData[1] = DataSource[i];
		MaxDataID[1] = i;
		}
	}
}
if(MaxDataID[1] != -1) OnTheRank[MaxDataID[1]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 2º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[2] && DataSource[i] <= MaxData[1] && MaxDataID[1] != i && OnTheRank[i] == false)
		{
		MaxData[2] = DataSource[i];
		MaxDataID[2] = i;
		}
	}
}
if(MaxDataID[2] != -1) OnTheRank[MaxDataID[2]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 3º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[3] && DataSource[i] <= MaxData[2] && MaxDataID[2] != i && OnTheRank[i] == false)
		{
		MaxData[3] = DataSource[i];
		MaxDataID[3] = i;
		}
	}
}
if(MaxDataID[3] != -1) OnTheRank[MaxDataID[3]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 4º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[4] && DataSource[i] <= MaxData[3] && MaxDataID[3] != i && OnTheRank[i] == false)
		{
		MaxData[4] = DataSource[i];
		MaxDataID[4] = i;
		}
	}
}
if(MaxDataID[4] != -1) OnTheRank[MaxDataID[4]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 5º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[5] && DataSource[i] <= MaxData[4] && MaxDataID[4] != i && OnTheRank[i] == false)
		{
		MaxData[5] = DataSource[i];
		MaxDataID[5] = i;
		}
	}
}
if(MaxDataID[5] != -1) OnTheRank[MaxDataID[5]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 6º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[6] && DataSource[i] <= MaxData[5] && MaxDataID[5] != i && OnTheRank[i] == false)
		{
		MaxData[6] = DataSource[i];
		MaxDataID[6] = i;
		}
	}
}
if(MaxDataID[6] != -1) OnTheRank[MaxDataID[6]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 7º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[7] && DataSource[i] <= MaxData[6] && MaxDataID[6] != i && OnTheRank[i] == false)
		{
		MaxData[7] = DataSource[i];
		MaxDataID[7] = i;
		}
	}
}
if(MaxDataID[7] != -1) OnTheRank[MaxDataID[7]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 8º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[8] && DataSource[i] <= MaxData[7] && MaxDataID[7] != i && OnTheRank[i] == false)
		{
		MaxData[8] = DataSource[i];
		MaxDataID[8] = i;
		}
	}
}
if(MaxDataID[8] != -1) OnTheRank[MaxDataID[8]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 9º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[9] && DataSource[i] <= MaxData[8] && MaxDataID[8] != i && OnTheRank[i] == false)
		{
		MaxData[9] = DataSource[i];
		MaxDataID[9] = i;
		}
	}
}
if(MaxDataID[9] != -1) OnTheRank[MaxDataID[9]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 10º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[10] && DataSource[i] <= MaxData[9] && MaxDataID[9] != i && OnTheRank[i] == false)
		{
		MaxData[10] = DataSource[i];
		MaxDataID[10] = i;
		}
	}
}
if(MaxDataID[10] != -1) OnTheRank[MaxDataID[10]] = true;

for(new i; i < 11; i++)
{
	if(MaxDataID[i] != -1)
	{
	new Name[MAX_PLAYER_NAME];
	GetPlayerName(MaxDataID[i], Name, sizeof(Name));
	format(Ranking, sizeof(Ranking), "%s\n%iº - {00FF00}%s(%i){FF5A00} - %i", Ranking,i,Name,MaxDataID[i],MaxData[i]);
	}
}

format(DialogString, sizeof(DialogString), "{FF5A00}%s\n\n{FFFF00}Esta lista exibe somente quem está online",Ranking);
ShowPlayerDialog(playerid,9559,DIALOG_STYLE_MSGBOX,"Ranking de score",DialogString,"OK","Voltar");
return 1;}


stock ShowTopTenKillsForPlayer(playerid)
{
new MaxData[11];
new MaxDataID[11];
new bool:OnTheRank[MAX_PLAYERS];
new DataSource[MAX_PLAYERS];
new Ranking[570];
new DialogString[1000];

for(new i; i < GetMaxPlayers(); i++)
{
	if(IsPlayerConnected(i)) DataSource[i] = ScoreNaSessao[i]; //FONTE DE DADOS DO RANKING
}

for(new i; i < 11; i++){MaxData[i] = -1;MaxDataID[i] = -1;} //Preparar variáveis

for(new i; i < GetMaxPlayers(); i++) // Posição 1º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[1])
		{
		MaxData[1] = DataSource[i];
		MaxDataID[1] = i;
		}
	}
}
if(MaxDataID[1] != -1) OnTheRank[MaxDataID[1]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 2º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[2] && DataSource[i] <= MaxData[1] && MaxDataID[1] != i && OnTheRank[i] == false)
		{
		MaxData[2] = DataSource[i];
		MaxDataID[2] = i;
		}
	}
}
if(MaxDataID[2] != -1) OnTheRank[MaxDataID[2]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 3º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[3] && DataSource[i] <= MaxData[2] && MaxDataID[2] != i && OnTheRank[i] == false)
		{
		MaxData[3] = DataSource[i];
		MaxDataID[3] = i;
		}
	}
}
if(MaxDataID[3] != -1) OnTheRank[MaxDataID[3]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 4º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[4] && DataSource[i] <= MaxData[3] && MaxDataID[3] != i && OnTheRank[i] == false)
		{
		MaxData[4] = DataSource[i];
		MaxDataID[4] = i;
		}
	}
}
if(MaxDataID[4] != -1) OnTheRank[MaxDataID[4]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 5º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[5] && DataSource[i] <= MaxData[4] && MaxDataID[4] != i && OnTheRank[i] == false)
		{
		MaxData[5] = DataSource[i];
		MaxDataID[5] = i;
		}
	}
}
if(MaxDataID[5] != -1) OnTheRank[MaxDataID[5]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 6º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[6] && DataSource[i] <= MaxData[5] && MaxDataID[5] != i && OnTheRank[i] == false)
		{
		MaxData[6] = DataSource[i];
		MaxDataID[6] = i;
		}
	}
}
if(MaxDataID[6] != -1) OnTheRank[MaxDataID[6]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 7º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[7] && DataSource[i] <= MaxData[6] && MaxDataID[6] != i && OnTheRank[i] == false)
		{
		MaxData[7] = DataSource[i];
		MaxDataID[7] = i;
		}
	}
}
if(MaxDataID[7] != -1) OnTheRank[MaxDataID[7]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 8º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[8] && DataSource[i] <= MaxData[7] && MaxDataID[7] != i && OnTheRank[i] == false)
		{
		MaxData[8] = DataSource[i];
		MaxDataID[8] = i;
		}
	}
}
if(MaxDataID[8] != -1) OnTheRank[MaxDataID[8]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 9º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[9] && DataSource[i] <= MaxData[8] && MaxDataID[8] != i && OnTheRank[i] == false)
		{
		MaxData[9] = DataSource[i];
		MaxDataID[9] = i;
		}
	}
}
if(MaxDataID[9] != -1) OnTheRank[MaxDataID[9]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 10º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[10] && DataSource[i] <= MaxData[9] && MaxDataID[9] != i && OnTheRank[i] == false)
		{
		MaxData[10] = DataSource[i];
		MaxDataID[10] = i;
		}
	}
}
if(MaxDataID[10] != -1) OnTheRank[MaxDataID[10]] = true;

for(new i; i < 11; i++)
{
	if(MaxDataID[i] != -1)
	{
	new Name[MAX_PLAYER_NAME];
	GetPlayerName(MaxDataID[i], Name, sizeof(Name));
	format(Ranking, sizeof(Ranking), "%s\n%iº - {00FF00}%s(%i){FF5A00} - %i", Ranking,i,Name,MaxDataID[i],MaxData[i]);
	}
}

format(DialogString, sizeof(DialogString), "{FF5A00}%s\n\n{FFFF00}Esta lista exibe somente quem está online\nE somente os dados desde o login",Ranking);
ShowPlayerDialog(playerid,9559,DIALOG_STYLE_MSGBOX,"Ranking de kills",DialogString,"OK","Voltar");
return 1;}

stock ShowTopTenSpreeForPlayer(playerid)
{
new MaxData[11];
new MaxDataID[11];
new bool:OnTheRank[MAX_PLAYERS];
new DataSource[MAX_PLAYERS];
new Ranking[570];
new DialogString[1000];

for(new i; i < GetMaxPlayers(); i++)
{
	if(IsPlayerConnected(i)) DataSource[i] = Spree[i]; //FONTE DE DADOS DO RANKING
}

for(new i; i < 11; i++){MaxData[i] = -1;MaxDataID[i] = -1;} //Preparar variáveis

for(new i; i < GetMaxPlayers(); i++) // Posição 1º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[1])
		{
		MaxData[1] = DataSource[i];
		MaxDataID[1] = i;
		}
	}
}
if(MaxDataID[1] != -1) OnTheRank[MaxDataID[1]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 2º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[2] && DataSource[i] <= MaxData[1] && MaxDataID[1] != i && OnTheRank[i] == false)
		{
		MaxData[2] = DataSource[i];
		MaxDataID[2] = i;
		}
	}
}
if(MaxDataID[2] != -1) OnTheRank[MaxDataID[2]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 3º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[3] && DataSource[i] <= MaxData[2] && MaxDataID[2] != i && OnTheRank[i] == false)
		{
		MaxData[3] = DataSource[i];
		MaxDataID[3] = i;
		}
	}
}
if(MaxDataID[3] != -1) OnTheRank[MaxDataID[3]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 4º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[4] && DataSource[i] <= MaxData[3] && MaxDataID[3] != i && OnTheRank[i] == false)
		{
		MaxData[4] = DataSource[i];
		MaxDataID[4] = i;
		}
	}
}
if(MaxDataID[4] != -1) OnTheRank[MaxDataID[4]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 5º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[5] && DataSource[i] <= MaxData[4] && MaxDataID[4] != i && OnTheRank[i] == false)
		{
		MaxData[5] = DataSource[i];
		MaxDataID[5] = i;
		}
	}
}
if(MaxDataID[5] != -1) OnTheRank[MaxDataID[5]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 6º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[6] && DataSource[i] <= MaxData[5] && MaxDataID[5] != i && OnTheRank[i] == false)
		{
		MaxData[6] = DataSource[i];
		MaxDataID[6] = i;
		}
	}
}
if(MaxDataID[6] != -1) OnTheRank[MaxDataID[6]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 7º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[7] && DataSource[i] <= MaxData[6] && MaxDataID[6] != i && OnTheRank[i] == false)
		{
		MaxData[7] = DataSource[i];
		MaxDataID[7] = i;
		}
	}
}
if(MaxDataID[7] != -1) OnTheRank[MaxDataID[7]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 8º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[8] && DataSource[i] <= MaxData[7] && MaxDataID[7] != i && OnTheRank[i] == false)
		{
		MaxData[8] = DataSource[i];
		MaxDataID[8] = i;
		}
	}
}
if(MaxDataID[8] != -1) OnTheRank[MaxDataID[8]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 9º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[9] && DataSource[i] <= MaxData[8] && MaxDataID[8] != i && OnTheRank[i] == false)
		{
		MaxData[9] = DataSource[i];
		MaxDataID[9] = i;
		}
	}
}
if(MaxDataID[9] != -1) OnTheRank[MaxDataID[9]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 10º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[10] && DataSource[i] <= MaxData[9] && MaxDataID[9] != i && OnTheRank[i] == false)
		{
		MaxData[10] = DataSource[i];
		MaxDataID[10] = i;
		}
	}
}
if(MaxDataID[10] != -1) OnTheRank[MaxDataID[10]] = true;

for(new i; i < 11; i++)
{
	if(MaxDataID[i] != -1)
	{
	new Name[MAX_PLAYER_NAME];
	GetPlayerName(MaxDataID[i], Name, sizeof(Name));
	format(Ranking, sizeof(Ranking), "%s\n%iº - {00FF00}%s(%i){FF5A00} - %i", Ranking,i,Name,MaxDataID[i],MaxData[i]);
	}
}

format(DialogString, sizeof(DialogString), "{FF5A00}%s\n\n{FFFF00}Esta lista exibe somente quem está online\nSpree é o score ganho sem ter morrido",Ranking);
ShowPlayerDialog(playerid,9559,DIALOG_STYLE_MSGBOX,"Ranking de spree",DialogString,"OK","Voltar");
return 1;}

stock ShowTopTenDinheiroForPlayer(playerid)
{
new MaxData[11];
new MaxDataID[11];
new bool:OnTheRank[MAX_PLAYERS];
new DataSource[MAX_PLAYERS];
new Ranking[570];
new DialogString[1000];

for(new i; i < GetMaxPlayers(); i++)
{
	if(IsPlayerConnected(i)) DataSource[i] = CallRemoteFunction("GetPlayerCash","i",i); //FONTE DE DADOS DO RANKING
}

for(new i; i < 11; i++){MaxData[i] = -1;MaxDataID[i] = -1;} //Preparar variáveis

for(new i; i < GetMaxPlayers(); i++) // Posição 1º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[1])
		{
		MaxData[1] = DataSource[i];
		MaxDataID[1] = i;
		}
	}
}
if(MaxDataID[1] != -1) OnTheRank[MaxDataID[1]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 2º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[2] && DataSource[i] <= MaxData[1] && MaxDataID[1] != i && OnTheRank[i] == false)
		{
		MaxData[2] = DataSource[i];
		MaxDataID[2] = i;
		}
	}
}
if(MaxDataID[2] != -1) OnTheRank[MaxDataID[2]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 3º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[3] && DataSource[i] <= MaxData[2] && MaxDataID[2] != i && OnTheRank[i] == false)
		{
		MaxData[3] = DataSource[i];
		MaxDataID[3] = i;
		}
	}
}
if(MaxDataID[3] != -1) OnTheRank[MaxDataID[3]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 4º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[4] && DataSource[i] <= MaxData[3] && MaxDataID[3] != i && OnTheRank[i] == false)
		{
		MaxData[4] = DataSource[i];
		MaxDataID[4] = i;
		}
	}
}
if(MaxDataID[4] != -1) OnTheRank[MaxDataID[4]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 5º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[5] && DataSource[i] <= MaxData[4] && MaxDataID[4] != i && OnTheRank[i] == false)
		{
		MaxData[5] = DataSource[i];
		MaxDataID[5] = i;
		}
	}
}
if(MaxDataID[5] != -1) OnTheRank[MaxDataID[5]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 6º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[6] && DataSource[i] <= MaxData[5] && MaxDataID[5] != i && OnTheRank[i] == false)
		{
		MaxData[6] = DataSource[i];
		MaxDataID[6] = i;
		}
	}
}
if(MaxDataID[6] != -1) OnTheRank[MaxDataID[6]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 7º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[7] && DataSource[i] <= MaxData[6] && MaxDataID[6] != i && OnTheRank[i] == false)
		{
		MaxData[7] = DataSource[i];
		MaxDataID[7] = i;
		}
	}
}
if(MaxDataID[7] != -1) OnTheRank[MaxDataID[7]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 8º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[8] && DataSource[i] <= MaxData[7] && MaxDataID[7] != i && OnTheRank[i] == false)
		{
		MaxData[8] = DataSource[i];
		MaxDataID[8] = i;
		}
	}
}
if(MaxDataID[8] != -1) OnTheRank[MaxDataID[8]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 9º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[9] && DataSource[i] <= MaxData[8] && MaxDataID[8] != i && OnTheRank[i] == false)
		{
		MaxData[9] = DataSource[i];
		MaxDataID[9] = i;
		}
	}
}
if(MaxDataID[9] != -1) OnTheRank[MaxDataID[9]] = true;

for(new i; i < GetMaxPlayers(); i++) // Posição 10º
{
    if(IsPlayerConnected(i))
    {
		if(DataSource[i] > MaxData[10] && DataSource[i] <= MaxData[9] && MaxDataID[9] != i && OnTheRank[i] == false)
		{
		MaxData[10] = DataSource[i];
		MaxDataID[10] = i;
		}
	}
}
if(MaxDataID[10] != -1) OnTheRank[MaxDataID[10]] = true;

for(new i; i < 11; i++)
{
	if(MaxDataID[i] != -1)
	{
	new Name[MAX_PLAYER_NAME];
	GetPlayerName(MaxDataID[i], Name, sizeof(Name));
	format(Ranking, sizeof(Ranking), "%s\n%iº - {00FF00}%s(%i){FF5A00} - $%i", Ranking,i,Name,MaxDataID[i],MaxData[i]);
	}
}

format(DialogString, sizeof(DialogString), "{FF5A00}%s\n\n{FFFF00}Esta lista exibe somente quem está online",Ranking);
ShowPlayerDialog(playerid,9559,DIALOG_STYLE_MSGBOX,"Ranking de dinheiro",DialogString,"OK","Voltar");
return 1;}

stock ShowNeonsForPlayer(playerid)
{
ShowPlayerDialog(playerid,9601,DIALOG_STYLE_LIST,"Escolha a cor do neon desejado:","1.\tRemover neon\n{FF0000}2.\tNeon vermelho\n{0000FF}3.\tNeon azul\n{00FF00}4.\tNeon verde\n{FFFF00}5.\tNeon amarelo\n{FF00FF}6.\tNeon rosa\n{FFFFFF}7.\tNeon branco\n{0000FF}8.\tGiroflex","OK","Voltar");
return 1;
}

stock ShowTela3ForPlayer(playerid)
{
ShowPlayerDialog(playerid,9602,DIALOG_STYLE_LIST,"Escolha o anúncio a seguir:","Limpar Anuncio TELA3\nAnunciar valor do Grana Fácil\nAnunciar /BAR aberto\nAnunciar evento\nAnunciar vagas de neon\nAnunciar REPORTS\nAnunciar ganho de FPS","OK","Voltar");
return 1;
}


stock AddNeons(playerid,type,objid)
{
if(veiculo[playerid] == 0) return 2;
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5){
if(Neons >= 20) return 2;}
DestroyNeons(playerid,false);
if(IsABike(veiculo[playerid])) return 2;
Neon[0][playerid] = CreateObject(objid,0,0,0,0,0,0,100.0);
Neon[1][playerid] = CreateObject(objid,0,0,0,0,0,0,100.0);
Neons++;Neons++;
if(type == 1){
AttachObjectToVehicle(Neon[0][playerid], veiculo[playerid], -0.8, 0.0, -0.60, 0.0, 0.0, 0.0);
AttachObjectToVehicle(Neon[1][playerid], veiculo[playerid], 0.8, 0.0, -0.60, 0.0, 0.0, 0.0);}
if(type == 2){
AttachObjectToVehicle(Neon[0][playerid], veiculo[playerid],0.2,0,0.75,0,0,0);
AttachObjectToVehicle(Neon[1][playerid], veiculo[playerid],-0.2,0,0.75,0,0,0);}
SendPlayerFormattedText(playerid, COLOUR_INFORMACAO, "[INFO]: Kit neon instalado com sucesso! {C0C0C0}[Veículos com neon: %i de 10]", Neons/2);
return 1;
}

stock DestroyNeons(playerid,bool:message)
{
new bool:Removido = false;

	if(Neon[0][playerid] != -1)
	{
	if(IsValidObject(Neon[0][playerid])) DestroyObject(Neon[0][playerid]);
	Neon[0][playerid] = -1;
	Neons--;
	Removido = true;
	}

	if(Neon[1][playerid] != -1)
	{
	if(IsValidObject(Neon[1][playerid])) DestroyObject(Neon[1][playerid]);
	Neon[1][playerid] = -1;
	Neons--;
	Removido = true;
	}

	if(message == true)
	{
	if(Removido == true)
	SendPlayerFormattedText(playerid, COLOUR_INFORMACAO, "[INFO]: Kit neon {FF0000}removido{00FF00} com sucesso! {C0C0C0}[Veículos com neon: %i de 10]", Neons/2);
	else
	SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não possui kit neon");
	}

return 1;
}

stock ShowRadiosForPlayer(playerid)
{
ShowPlayerDialog(playerid,9604,DIALOG_STYLE_LIST,"Escolha a musica que deseja ouvir:","Nenhuma musica (parar sons)\nRadio Hunter\nRock\nReggae\n","OK","Voltar");
return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){

if(dialogid == DIALOG_CRIAR)
	{
	new String[300];
		if(response)
		{
		    if(!strlen(inputtext))
				return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você tem que digitar um nome!"),
    			ShowPlayerDialog(playerid, DIALOG_CRIAR, DIALOG_STYLE_INPUT, "{FFFFFF}Criando um Cla", "{FFFFFF}Escreva abaixo o Nome da\n{FFFFFF}Cla que você deseja criar", "Criar", "Cancelar");
			format(String, sizeof(String), "{0DD0DE}Menu do Cla %s", inputtext);
			ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_LIST, String, "{FFFFFF}Nome do Cla\n{FFFFFF}Skin do Cla\n{FFFFFF}Convidar\n{FFFFFF}Promover\n{FFFFFF}Spawn\n{FFFFFF}Cor\n{FF0000}Demitir\n{FF0000}Encerrar Cla", "Ver", "Cancelar");
			format(String, sizeof(String), "[CLA]: O Jogador {FFFFFF}%s{00A4D6} criou o CLA {FFFFFF}[%s]", Nome(playerid), inputtext);
			SendClientMessageToAll(COLOUR_INFORMACAOGANG, String);
			gangs++;
			if(gangs > MAX_GANGS)
			{
			    format(String, sizeof(String), "[ERRO]: O servidor ja possui o maximo de clans ( %d ), Cominique um Admin.", MAX_GANGS);
			    SendClientMessage(playerid, COLOUR_ERRO, String);
			    return 0;
			}

            for(new t = 0; t < MAX_GANGS; t++)
            {
                format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", gangs);
                if(DOF2_FileExists(String))
                gangs++;
			}
			GangInfo[gangs][ID] = Gang[gangs];
			PlayerDados[playerid][Lider] = GangInfo[playerid][ID];
			format(StringGang, sizeof(StringGang), "LAGANGS/Gangs/%d.ini", gangs);
			DOF2_CreateFile(StringGang);
			DOF2_SetInt(StringGang, "ID", gangs);
			DOF2_SetString(StringGang, "Nome", inputtext);
			format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
			DOF2_CreateFile(String);
			DOF2_SetInt(String, "Lider", gangs);
			DOF2_SetInt(String, "Membro", gangs);
			PlayerDados[playerid][Lider] = gangs;
			PlayerDados[playerid][Membro] = gangs;
			DOF2_SetInt(String, "Cargo", 1);
			PlayerDados[playerid][Cargo] = 1;
			DOF2_SaveFile();
			new StringCor[20];
			format(StringCor, sizeof(StringCor), "0xFFFFFFFF");
			new Cor = HexToInt(StringCor);
			cor[playerid] = Cor;
			SetPlayerColor(playerid, Cor);
         	SetarCorHmc(playerid, Cor);
		}
		return 1;
	}
	if(dialogid == DIALOG_INFO)
	{
	    if(response)
	    {
			new String[300];
	        if(listitem == 0)
	        {
				format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
	            format(String, sizeof(String), "{FFFFFF}O atual nome do CLA é {1BE032}%s{FFFFFF}\n\nEscreva o novo nome", DOF2_GetString(String, "Nome"));
	            ShowPlayerDialog(playerid, DIALOG_NOMEG, DIALOG_STYLE_INPUT, "Nome do Cla", String, "Mudar", "Cancelar");
	            return 1;
			}
			if(listitem == 1)
			{
			    format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
			    if(!DOF2_IsSet(String, "Skin"))
				{
					ShowPlayerDialog(playerid, DIALOG_SKIN, DIALOG_STYLE_INPUT, "Skin do Cla", "{FFFFFF}O Skin do Cla ainda não Está Definido\n\nDigite o ID da skin para defini-lo", "Definir", "Cancelar");
					return 1;
				}
				format(String, sizeof(String), "{FFFFFF}O atual skin do Cla é o {1BE032}%d{FFFFFF}\n\nColoque o novo ID abaixo", ArquivoGangInt(playerid, "Skin"));
				ShowPlayerDialog(playerid, DIALOG_SKIN, DIALOG_STYLE_INPUT, "Skin do CLA", String, "Definir", "Cancelar");
				return 1;
			}
			if(listitem == 2)
			{
			    ShowPlayerDialog(playerid, DIALOG_CONVIDAR, DIALOG_STYLE_INPUT, "Convidando um jogador", "{FFFFFF}Digite abaixo o ID do jogador\nPara Convida-lo para seu CLA", "Convidar", "Cancelar");
			    return 1;
			}
			if(listitem == 3)
			{
			    ShowPlayerDialog(playerid, DIALOG_PROMOVER, DIALOG_STYLE_INPUT, "Promovendo um jogador", "{FFFFFF}Digite abaixo o ID do Jogador\nQue deseja promover", "Avancar", "Cancelar");
			    return 1;
			}
			if(listitem == 4)
			{
			    ShowPlayerDialog(playerid, DIALOG_SPAWN, DIALOG_STYLE_MSGBOX, "Local do Spawn", "{FF00E1}Vá até o local onde você deseja\nque seja o Spawn da seu cla e\ndigite 'aqui' sem aspas", "Ok", "Cancelar");
				PlayerDados[playerid][LocalSpawn] = true;
				return 1;
			}
			if(listitem == 5)
			{
			    ShowPlayerDialog(playerid, DIALOG_COR, DIALOG_STYLE_LIST, "{FFFFFF}Cor do Nick dos Membros", "{FF0505}Vermelho \n{FF05FB}Rosa \n{0D05FF}Azul \n{05FFE2}Azul Claro \n{048706}Verde \n{0DFF05}Verde Claro \n{FFFF05}Amarelo \n{FF9705}Laranjado \n{FFFFFF}Branco", "Mudar", "Cancelar");
			    return 1;
			}
			if(listitem == 6)
			{
			    ShowPlayerDialog(playerid, DIALOG_DEMITIR, DIALOG_STYLE_INPUT, "Demitindo um Membro", "{FFFFFF}Digite abaixo o ID do jogador que\ndeseja demitir", "Demitir", "Cancelar");
			    return 1;
			}
			if(listitem == 7)
			{
			    ShowPlayerDialog(playerid, DIALOG_ENCERRAR, DIALOG_STYLE_MSGBOX, "{FFFFFF}Encerrando o cla", "{FC3236}Tem certeza que deseja acabar\ncom a seu Cla?", "Sim", "Não");
			    return 1;
			}
		}
	}
	if(dialogid == DIALOG_ENCERRAR)
	{
	    if(response)
	    {
	        new String[300];
	        new str[128];
	        new str2[128];
	        for(new i = 0; i < MAX_PLAYERS; i++)
	        {
	            if(PlayerDados[i][Membro] == PlayerDados[playerid][Lider]){
					format(str2, sizeof(str2), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Membro]);
	            	format(str, sizeof(str), "LAGANGS/Players/%s.ini", Nome(i));
					PlayerDados[i][Lider] = 0;
	            	PlayerDados[i][Cargo] = 0;
	            	PlayerDados[i][Membro] = 0;
	            	ExcluiGang = true;
	            	format(str, sizeof(str), "LAGANGS/Players/%s.ini", PlayerDados[playerid][Membro]);
	            	DOF2_RemoveFile(str);
				}
			}
			if(ExcluiGang == true){
			    format(str, sizeof(str), "LAGANGS/Gangs/%d.ini", GangPlayer(playerid));
                format(String, sizeof(String), "[CLA]: O Lider {FFFFFF}%s{77ADB5} encerrou o CLA {FFFFFF}%s!.", Nome(playerid), DOF2_GetString(str, "Nome"));
  				AvisoLider(playerid, String);
  				DOF2_RemoveFile(str);
    			ExcluiGang = false;
			}
		}
		if(!response) DialogGang(playerid);
	}
    if(dialogid == DIALOG_COR)
	{
	    if(response)
	    {
            if(listitem == 0) return SetarCor(playerid, 0xFF050596, "[CLA]: O Lider do CLA alterou a cor de todos os Membros para Vermelho");
	        if(listitem == 1) return SetarCor(playerid, 0xFF05FB96, "[CLA]: O Lider do CLA alterou a cor de todos os Membros para Rosa");
	        if(listitem == 2) return SetarCor(playerid, 0x0D05FF96, "[CLA]: O Lider do CLA alterou a cor de todos os Membros para Azul");
	        if(listitem == 3) return SetarCor(playerid, 0x05FFE296, "[CLA]: O Lider do CLA alterou a cor de todos os Membros para Azul Claro");
	        if(listitem == 4) return SetarCor(playerid, 0x04870696, "[CLA]: O Lider do CLA alterou a cor de todos os Membros para Verde");
	        if(listitem == 5) return SetarCor(playerid, 0x0DFF0596, "[CLA]: O Lider do CLA alterou a cor de todos os Membros para Verde Claro");
	        if(listitem == 6) return SetarCor(playerid, 0xFFFF0596, "[CLA]: O Lider do CLA alterou a cor de todos os Membros para Amarelo");
	        if(listitem == 7) return SetarCor(playerid, 0xFF970596, "[CLA]: O Lider do CLA alterou a cor de todos os Membros para Laranjado");
	        if(listitem == 8) return SetarCor(playerid, 0xFFFFFF96, "[CLA]:O Lider do CLA alterou a cor de todos os Membros para Branco");
		}
		if(!response) DialogGang(playerid);
	}
	if(dialogid == DIALOG_SPAWN)
	{
	    if(!response)
	    {
	        DialogGang(playerid);
	        PlayerDados[playerid][LocalSpawn] = false;
		}
	}
	if(dialogid == DIALOG_DEMITIR)
	{
	    if(response)
	    {
	        new String[300];
            new str1[128];
	        format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
	        format(str1, sizeof(str1), "LAGANGS/Players/%s.ini", Nome(strval(inputtext)));
	        if(!IsPlayerConnected(strval(inputtext)))
	        {
	            SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Jogador não esta conectado!");
	            ShowPlayerDialog(playerid, DIALOG_PROMOVER, DIALOG_STYLE_INPUT, "Demitindo um Membro", "{FFFFFF}Digite abaixo o ID do jogador que\ndeseja demitir", "Demitir", "Cancelar");
				return 1;
			}
	        /*if(DOF2_GetInt(str1, "Membro") != DOF2_GetInt(String, "Lider"))
	        {
	            SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você só pode demitir !");
	            ShowPlayerDialog(playerid, DIALOG_DEMITIR, DIALOG_STYLE_INPUT, "Demitindo um Membro", "{FFFFFF}Digite abaixo o ID do jogador que\ndeseja demitir", "Demitir", "Cancelar");
	            return 1;
			}*/

			if(PlayerDados[strval(inputtext)][Lider] == PlayerDados[playerid][Lider]) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce não pode demitir um lider! Use {FFFFFF}/INFOCLA!");
	        format(String, sizeof(String), "[CLA]: O lider removeu o jogador {FFFFFF}%s{21CC21} do CLA!", Nome(strval(inputtext)));
			AvisoLider(playerid, String);
	        PlayerDados[strval(inputtext)][Membro] = 0;
	        PlayerDados[strval(inputtext)][Lider] = 0;
	        PlayerDados[strval(inputtext)][Cargo] = 0;
	        SetPlayerSkin(strval(inputtext), 3);
		}
		if(!response) return DialogGang(playerid);
	}
	if(dialogid == DIALOG_PROMOVER)
	{
	    if(response)
	    {
	        new str1[128];
	        new String[300];
	        format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
	        format(str1, sizeof(str1), "LAGANGS/Players/%s.ini", Nome(strval(inputtext)));
	        if(!IsPlayerConnected(strval(inputtext)))
	        {
	            SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Jogador não esta conectado!");
	            ShowPlayerDialog(playerid, DIALOG_PROMOVER, DIALOG_STYLE_INPUT, "Promovendo um jogador", "Digite abaixo o ID do Jogador\nQue deseja promover", "Avancar", "Cancelar");
  				return 1;
			}
	        /*if(DOF2_GetInt(str1, "Membro") != DOF2_GetInt(String, "Lider"))
	        {
	            SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você só pode promover um jogador da sua gang!");
	            ShowPlayerDialog(playerid, DIALOG_PROMOVER, DIALOG_STYLE_INPUT, "Promovendo um jogador", "Digite abaixo o ID do Jogador\nQue deseja promover", "Avancar", "Cancelar");
	            return 1;
			}*/
			IdPromovido = strval(inputtext);

			format(String, sizeof(String), "{FFFFFF}Digite abaixo o cargo que\nvocê deseja dar ao jogador {3BEDC7}ID %d", IdPromovido);
			ShowPlayerDialog(playerid, DIALOG_PROMOVER2, DIALOG_STYLE_INPUT, "Promovendo um Jogador", String, "Promover", "Voltar");
		}
		if(!response) return DialogGang(playerid);
		return 1;
	}
	if(dialogid == DIALOG_PROMOVER2)
	{
	    if(response)
	    {
	    new String[300];
	        if(PlayerDados[playerid][Membro] == 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Player escolhido não faz parte do clã!");
	        if(strval(inputtext) > 5 || strval(inputtext) < 1)
	        {
	            SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O cargo Máximo é 5 e o mínimo é 1!");
	            format(String, sizeof(String), "Digite abaixo o cargo que\nvocê deseja dar ao jogador ID {3BEDC7}%d", IdPromovido);
				ShowPlayerDialog(playerid, DIALOG_PROMOVER2, DIALOG_STYLE_INPUT, "Promovendo um Jogador", String, "Promover", "Voltar");
				return 0;
			}
			for(new i = 0; i < MAX_PLAYERS; i++)
	        {
	            if(PlayerDados[i][Membro] == PlayerDados[playerid][Membro])
	            {
	                format(String, sizeof(String), "[CLA]: O lider promoveu o jogador {FFFFFF}%s{21CC21} para o CARGO {FF0000}%d!", Nome(IdPromovido), strval(inputtext));
	                SendClientMessage(i, COLOUR_INFORMACAO, String);
				}
			}
			PlayerDados[IdPromovido][Cargo] = strval(inputtext);
			SalvarDados(IdPromovido);
			DOF2_SaveFile();
		}
		if(!response) return DialogGang(playerid);
	}
	if(dialogid == DIALOG_CONVIDAR)
	{
	    if(response)
	    {
	    new String[300];
	    
	        if(!strlen(inputtext))
	        {
	            SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Digite um ID Válido!");
	            ShowPlayerDialog(playerid, DIALOG_CONVIDAR, DIALOG_STYLE_INPUT, "Convidando um jogador", "Digite abaixo o ID do jogador\nPara Convida-lo para seu CLA", "Convidar", "Cancelar");
				return 1;
			}
			if(PlayerDados[strval(inputtext)][Lider] > 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Nao é possivel convidar alguem que já é lider outro cla!");
			if(PlayerDados[strval(inputtext)][Membro] > 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Nao é possivel convidar alguem que já é membro de outro cla!");
		 	if(!IsPlayerConnected(strval(inputtext)))
		 	{
				SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Jogador não esta conectado!");
				ShowPlayerDialog(playerid, DIALOG_CONVIDAR, DIALOG_STYLE_INPUT, "Convidando um jogador", "Digite abaixo o ID do jogador\nPara Convida-lo para seu cla", "Convidar", "Cancelar");
				return 1;
			}
			new str[256];
			format(str, sizeof(str), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
			format(String, sizeof(String), "{FFFFFF}Você está sendo convidado pelo Lider {3BEDC7}%s{FFFFFF}\nPara participar do cla {3BEDC7}%s", Nome(playerid), DOF2_GetString(str, "Nome"));
			ShowPlayerDialog(strval(inputtext), DIALOG_CONVIDADO, DIALOG_STYLE_MSGBOX, "Convidado para o Cla", String, "Aceitar", "Recusar");
			format(String, sizeof(String), "Jogador %s [ID: %d] Convidado, aguarde a resposta", Nome(strval(inputtext)), strval(inputtext));
			SendClientMessage(playerid, COLOUR_DICA, String);
			IdConvidou = playerid;
			IdGangC = DOF2_GetInt(str, "ID");
		}
		if(!response) return DialogGang(playerid);
		return 1;
	}
	if(dialogid == DIALOG_CONVIDADO)
	{
	    if(response)
	    {
	    new String[300];
	    new str[128];
	        PlayerDados[playerid][Membro] = IdGangC;
			for(new i; i < MAX_PLAYERS; i++)
			{
			    if(PlayerDados[i][Membro] == PlayerDados[playerid][Membro])
			    {
			        format(String, sizeof(String), "[CLA]:  Jogador {FFFFFF}%s{00A4D6} aceitou o convite de {FFFFFF}%s{00A4D6} e é o mais novo membro do CLA!", Nome(playerid), Nome(IdConvidou));
                    format(str, sizeof(str), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Membro]);
                    PlayerDados[playerid][Cargo] = 1;
					SetPlayerSkin(playerid, ArquivoGangInt(playerid, "Skin"));
					SetPlayerColor(playerid, ArquivoGangHex(playerid, "CorG"));
					SendClientMessage(i, COLOUR_INFORMACAOGANG, String);
			        SalvarDados(i);
				}
			}
		}
		if(!response)
		{
		new String[300];
			format(String, sizeof(String), "[CLA]: O jogador {FFFFFF}%s{00A4D6} recusou seu convite!", Nome(playerid));
			SendClientMessage(IdConvidou, COLOUR_INFORMACAOGANG, String);
		}
	}
	if(dialogid == DIALOG_SKIN)
	{
	    if(response)
	    {
	    new String[300];
			if(!strlen(inputtext))
			{
			    SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Digite um numero válido!");
                format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
			    if(!DOF2_IsSet(String, "Skin"))
				{
					ShowPlayerDialog(playerid, DIALOG_SKIN, DIALOG_STYLE_INPUT, "Skin do CLA", "O Skin do Cla ainda não Está Definido\n\nDigite o ID da skin para defini-lo", "Definir", "Cancelar");
					return 1;
				}
				format(String, sizeof(String), "{FFFFFF}O Atual Skin do Cla é o {1BE032}%d{FFFFFF}\n\nColoque o novo ID abaixo",ArquivoGangInt(playerid, "Skin"));
				ShowPlayerDialog(playerid, DIALOG_SKIN, DIALOG_STYLE_INPUT, "Skin do Cla", String, "Definir", "Cancelar");
				return 1;
			}
			if(strval(inputtext) > 299)
			{
			    SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Numero maximo é 299!");
                format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
			    if(!DOF2_IsSet(String, "Skin"))
				{
					ShowPlayerDialog(playerid, DIALOG_SKIN, DIALOG_STYLE_INPUT, "Skin do Cla", "O Skin do Cla ainda não Está Definido\n\nDigite o ID da skin para defini-lo", "Definir", "Cancelar");
					return 1;
				}
				format(String, sizeof(String), "{FFFFFF}O Atual Skin do Cla é o {1BE032}%d{FFFFFF}\n\nColoque o novo ID abaixo",ArquivoGangInt(playerid, "Skin"));
				ShowPlayerDialog(playerid, DIALOG_SKIN, DIALOG_STYLE_INPUT, "Skin do Cla", String, "Definir", "Cancelar");
				return 1;
			}
	        format(String, sizeof(String), "[CLA]: O Lider do CLA mudou a skin de todos os membros para a {FFFFFF}%d!", strval(inputtext));
	        AvisoLider(playerid, String);
	        DOF2_SetInt(IdGang(playerid), "Skin", strval(inputtext));
	        for(new i = 0; i < MAX_PLAYERS; i++)
	        {
				if(PlayerDados[i][Membro] == PlayerDados[playerid][Lider])
				{
				    SetPlayerSkin(i, strval(inputtext));
				}
			}
			DialogGang(playerid);
		}
		if(!response)
		{new String[300];
		    format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
			format(String, sizeof(String), "{0DD0DE}Menu do CLA %s", DOF2_GetString(String, "Nome"));
			ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_LIST, String,"{FFFFFF}Nome do Cla\n{FFFFFF}Skin do Cla\n{FFFFFF}Convidar\n{FFFFFF}Promover\n{FFFFFF}Spawn\n{FFFFFF}Cor\n{FF0000}Demitir\n{FF0000}Encerrar Cla", "Ver", "Cancelar");
	    }
	}
	if(dialogid == DIALOG_NOMEG)
	{
	    if(response)
	    {
	    new String[300];
	        if(!strlen(inputtext))
			{
				SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Nome invalido");
				format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
				format(String, sizeof(String), "{FFFFFF}O Atual nome do CLA é {1BE032}%s{FFFFFF}\n\nEscreva o novo nome", DOF2_GetString(String, "Nome"));
	            ShowPlayerDialog(playerid, DIALOG_NOMEG, DIALOG_STYLE_INPUT, "Nome do Cla", String, "Mudar", "Cancelar");
	            return 0;
			}
	        format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
	        DOF2_SetString(String, "Nome", inputtext);
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
			    if(PlayerDados[i][Membro] == PlayerDados[playerid][Lider])
			    {
			        format(String, sizeof(String), "[CLA]: O lider {FFFFFF}%s{00A4D6} mudou o nome do CLA para {FFFFFF}%s!", Nome(playerid), inputtext);
			        SendClientMessage(i, COLOUR_INFORMACAOGANG, String);
				}
			}
			format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
			format(String, sizeof(String), "{0DD0DE}Menu do CLA %s", DOF2_GetString(String, "Nome"));
			ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_LIST, String,"{FFFFFF}Nome do Cla\n{FFFFFF}Skin do Cla\n{FFFFFF}Convidar\n{FFFFFF}Promover\n{FFFFFF}Spawn\n{FFFFFF}Cor\n{FF0000}Demitir\n{FF0000}Encerrar Cla", "Ver", "Cancelar");
		}
		if(!response)
		{new String[300];
		    format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
			format(String, sizeof(String), "{0DD0DE}Menu do Cla %s", DOF2_GetString(String, "Nome"));
			ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_LIST, String,"{FFFFFF}Nome do Cla\n{FFFFFF}Skin do Cla\n{FFFFFF}Convidar\n{FFFFFF}Promover\n{FFFFFF}Spawn\n{FFFFFF}Cor\n{FF0000}Demitir\n{FF0000}Encerrar Cla", "Ver", "Cancelar");
		}
	}

if(dialogid == VotacaoDialog) {
	if(response) {
		EnqueteVotou[playerid] = true;
		EnqueteVotosSim++;
		new SoundX,SoundY,SoundZ; PlayerPlaySound(playerid, 1057, SoundX, SoundY, SoundZ);
		SendClientMessage(playerid, Amarelo, "[INFO]: Seu voto \"sim\" foi registrado, obrigado por participar.");
	} else {
		EnqueteVotou[playerid] = true;
		EnqueteVotosNao++;
		new SoundX,SoundY,SoundZ; PlayerPlaySound(playerid, 1057, SoundX, SoundY, SoundZ);
		SendClientMessage(playerid, Amarelo, "[INFO]: Seu voto \"não\" foi registrado, obrigado por participar.");
	}
	return 1;
}

if(dialogid==bandana)
 {
  if(response)
  {
   if(listitem==0)
   {
            SetPlayerAttachedObject( playerid, 0, 18917, 2, 0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754);
   }
   if(listitem==1)
   {
            SetPlayerAttachedObject( playerid, 0, 18913, 2, 0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754);
   }
   if(listitem==2)
   {
            SetPlayerAttachedObject( playerid, 0, 18916, 2, 0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754);
   }
   if(listitem==3)
   {
            SetPlayerAttachedObject(playerid, 0, 18915, 2, 0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754);
   }
   if(listitem==4)
   {
            SetPlayerAttachedObject(playerid, 0, 18912 , 2, 0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754);
   }
   if(listitem==5)
   {
            SetPlayerAttachedObject(playerid, 0, 18911 , 2, 0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754);
   }
   if(listitem==6)
   {
            SetPlayerAttachedObject( playerid, 0, 18914, 2, 0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754);
   }
   if(listitem==7)
   {
            SetPlayerAttachedObject(playerid, 0, 18918, 2, 0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754);
   }
   if(listitem==8)
   {
            SetPlayerAttachedObject(playerid, 0, 18920 , 2, 0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754);
   }
   if(listitem==9)
            {
            SetPlayerAttachedObject(playerid, 0, 18919 , 2, 0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754);
   }
   if(listitem==10)
   {
            for(new i;i<5;i++) RemovePlayerAttachedObject(playerid,i);
   }
  }
        return 1;
 }


//EVENTOS PRONTOS
if(dialogid == EventoProntoDialog){
    if(response){
        if(listitem == 0){ //ESCONDE ESCONDE MOTEL LS
			if(EventoAtivo == 0){
				SetPlayerPos(playerid, 2220.8938, -1148.6985, 1025.7969);
				SetPlayerFacingAngle(playerid, 0.4498);
				SetCameraBehindPlayer(playerid);
				GivePlayerWeapon(playerid, 38, 99999);
				SetPlayerInterior(playerid, 15);
				SetPlayerVirtualWorld(playerid, 1000);

				evento_x = 2220.8938;
				evento_y = -1148.6985;
				evento_z = 1025.7969;
				evento_f = 0.4498;

   				evento_vw = 1000;
				evento_in = 15;

				EventoAtivo = 1;
				EventoAdminID = playerid;
				EventoPausado = 1;
				if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) EventoOHK = false;
   				SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Evento ativado. Digite /eventoliberar para liberá-lo!");

   				EventoNome = "ESCONDE-ESCONDE (MLS)";
				EventoSPA = false;
				EventoSemDanos = true;
				EventoOHK = false;
				EventoRecarregarLife = false;
				EventoKitWalk = false;
				EventoKitRun = false;
				EventoProibirTele = true;
				EventoDarColete = 0;
				EventoDarLife = 0;
				EventoDarVeiculoID = 0;
				EventoDarArmaID = 0;
				EventoVeiculos = 0;
				EventoCarregar = 0;
				EventoDesarmar = 1;
				EventoGranadas = 0;
				EventoProibirCS = 1;
				EventoProibirGC = 0;
				EventoProibirFlip = 0;
				EventoMatarAoSairVeiculo = 0;
				ESCMLS = CreateObject(2669, 2215.38940, -1150.51099, 1026.06885,   0.00000, 0.00000, -89.00000);
			}else{
				EventoAtivo = 0;
				EventoAdminID = -1;
				EventoNome = "";
				SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Evento desativado, quem está nele será respawnado.");
				for(new i; i < GetMaxPlayers(); i++){
					if(IsPlayerConnected(i)){
						if(NoEvento[i] == 1) {
							SpawnPlayer(i);
							GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~r~EVENTO ENCERRADO!", 5000, 5);
						}
					}
				}
				DestroyObject(MTAREA51[0]);
				DestroyObject(MTAREA51[1]);
				DestroyObject(MTAREA51[2]);
				DestroyObject(MTAREA51[3]);
				DestroyObject(MTAREA51[4]);
				DestroyObject(ESCMLS);
				DestroyObject(ESCMDLS[0]);
				DestroyObject(ESCMDLS[1]);
				DestroyObject(ESCCF);
				DestroyObject(SKYFALL);
				EventoSkyFall = false;
				DestroyObject(CorridaCC);
				DestroyObject(CorridaLV);
				EventoCorridaCC = false;
				EventoCorridaLV = false;
			}
		}
		if(listitem == 1){ //ESCONDE ESCONDE MOTEL MDLS
            if(EventoAtivo == 0){
				SetPlayerPos(playerid, 1274.5212, -781.2128, 1089.9375);
				SetPlayerFacingAngle(playerid, 270.6132);
				SetCameraBehindPlayer(playerid);
				GivePlayerWeapon(playerid, 38, 99999);
				SetPlayerInterior(playerid, 5);
				SetPlayerVirtualWorld(playerid, 1000);

				evento_x = 1274.5212;
				evento_y = -781.2128;
				evento_z = 1089.9375;
				evento_f = 270.6132;

   				evento_vw = 1000;
				evento_in = 5;

				EventoAtivo = 1;
				EventoAdminID = playerid;
				EventoPausado = 1;
				if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) EventoOHK = false;
   				SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Evento ativado. Digite /eventoliberar para liberá-lo!");

   				EventoNome = "ESCONDE-ESCONDE(MDLS)";
				EventoSPA = false;
				EventoSemDanos = true;
				EventoOHK = false;
				EventoRecarregarLife = false;
				EventoKitWalk = false;
				EventoKitRun = false;
				EventoProibirTele = true;
				EventoDarColete = 0;
				EventoDarLife = 0;
				EventoDarVeiculoID = 0;
				EventoDarArmaID = 0;
				EventoVeiculos = 0;
				EventoCarregar = 0;
				EventoDesarmar = 1;
				EventoGranadas = 0;
				EventoProibirCS = 1;
				EventoProibirGC = 0;
				EventoProibirFlip = 0;
				EventoMatarAoSairVeiculo = 0;
				ESCMDLS[0] = CreateObject(2669, 1261.94910, -785.46136, 1092.12732,   0.00000, 0.00000, 0.00000);
				ESCMDLS[1] = CreateObject(2669, 1298.88928, -796.26941, 1084.18372,   0.00000, 0.00000, 1.00000);

			}else{
				EventoAtivo = 0;
				EventoAdminID = -1;
				EventoNome = "";
				SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Evento desativado, quem está nele será respawnado.");
				for(new i; i < GetMaxPlayers(); i++){
					if(IsPlayerConnected(i)){
						if(NoEvento[i] == 1) {
							SpawnPlayer(i);
							GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~r~EVENTO ENCERRADO!", 5000, 5);
						}
					}
				}
				DestroyObject(MTAREA51[0]);
				DestroyObject(MTAREA51[1]);
				DestroyObject(MTAREA51[2]);
				DestroyObject(MTAREA51[3]);
				DestroyObject(MTAREA51[4]);
				DestroyObject(ESCMLS);
				DestroyObject(ESCMDLS[0]);
				DestroyObject(ESCMDLS[1]);
				DestroyObject(ESCCF);
				DestroyObject(SKYFALL);
				EventoSkyFall = false;
				DestroyObject(CorridaCC);
				DestroyObject(CorridaLV);
				EventoCorridaCC = false;
				EventoCorridaLV = false;
			}
		}
		if(listitem == 2){ //ESCONDE ESCONDE CRACK FACTORY
			if(EventoAtivo == 0){
				SetPlayerPos(playerid, 2542.0242, -1318.4259, 1031.4219);
				SetPlayerFacingAngle(playerid, 91.8348);
				SetCameraBehindPlayer(playerid);
				GivePlayerWeapon(playerid, 38, 99999);
				SetPlayerInterior(playerid, 2);
				SetPlayerVirtualWorld(playerid, 1000);

				evento_x = 2542.0242;
				evento_y = -1318.4259;
				evento_z = 1031.4219;
				evento_f = 91.8348;

   				evento_vw = 1000;
				evento_in = 2;

				EventoAtivo = 1;
				EventoAdminID = playerid;
				EventoPausado = 1;
				if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) EventoOHK = false;
   				SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Evento ativado. Digite /eventoliberar para liberá-lo!");

   				EventoNome = "ESCONDE-ESCONDE (CF)";
				EventoSPA = false;
				EventoSemDanos = true;
				EventoOHK = false;
				EventoRecarregarLife = false;
				EventoKitWalk = false;
				EventoKitRun = false;
				EventoProibirTele = true;
				EventoDarColete = 0;
				EventoDarLife = 0;
				EventoDarVeiculoID = 0;
				EventoDarArmaID = 0;
				EventoVeiculos = 0;
				EventoCarregar = 0;
				EventoDesarmar = 1;
				EventoGranadas = 0;
				EventoProibirCS = 1;
				EventoProibirGC = 0;
				EventoProibirFlip = 0;
				EventoMatarAoSairVeiculo = 0;
				ESCCF = CreateObject(2669, 2542.78491, -1304.18884, 1025.24756,   0.00000, 0.00000, -91.00000);
			}else{
				EventoAtivo = 0;
				EventoAdminID = -1;
				EventoNome = "";
				SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Evento desativado, quem está nele será respawnado.");
				for(new i; i < GetMaxPlayers(); i++){
					if(IsPlayerConnected(i)){
						if(NoEvento[i] == 1) {
							SpawnPlayer(i);
							GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~r~EVENTO ENCERRADO!", 5000, 5);
						}
					}
				}
				DestroyObject(MTAREA51[0]);
				DestroyObject(MTAREA51[1]);
				DestroyObject(MTAREA51[2]);
				DestroyObject(MTAREA51[3]);
				DestroyObject(MTAREA51[4]);
				DestroyObject(ESCMLS);
				DestroyObject(ESCMDLS[0]);
				DestroyObject(ESCMDLS[1]);
				DestroyObject(ESCCF);
				DestroyObject(SKYFALL);
				EventoSkyFall = false;
				DestroyObject(CorridaCC);
				DestroyObject(CorridaLV);
				EventoCorridaCC = false;
				EventoCorridaLV = false;
			}
		}
		if(listitem == 3){ //SKYFALL (CAIR NO PONTO PISCANDO)
            if(EventoAtivo == 0){
                EventoSkyFall = true;
				SetPlayerPos(playerid, 1280.6121,-798.4644,88.3151);
				SetPlayerFacingAngle(playerid, 179.3224);
				SetCameraBehindPlayer(playerid);
				GivePlayerWeapon(playerid, 38, 99999);

				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 1000);

				evento_x = 1130.9325;
				evento_y = -1484.2947;
				evento_z = 1051.2657;
				evento_f = 166.7409;

   				evento_vw = 1000;
				evento_in = 0;

				EventoAtivo = 1;
				EventoAdminID = playerid;
				EventoPausado = 1;
				if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) EventoOHK = false;
   				SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Evento ativado. Digite /eventoliberar para liberá-lo!");

   				EventoNome = "SKYFALL";
				EventoSPA = false;
				EventoSemDanos = true;
				EventoOHK = false;
				EventoRecarregarLife = false;
				EventoKitWalk = false;
				EventoKitRun = false;
				EventoProibirTele = true;
				EventoDarColete = 0;
				EventoDarLife = 0;
				EventoDarVeiculoID = 0;
				EventoDarArmaID = 46;
				EventoVeiculos = 0;
				EventoCarregar = 0;
				EventoDesarmar = 1;
				EventoGranadas = 0;
				EventoProibirCS = 1;
				EventoProibirGC = 0;
				EventoProibirFlip = 0;
				EventoMatarAoSairVeiculo = 0;
				SKYFALL = CreateObject(18759, 1130.93250, -1484.29468, 1050.90173,   0.00000, 0.00000, 0.00000);
			}else{
				EventoAtivo = 0;
				EventoAdminID = -1;
				EventoNome = "";
				SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Evento desativado, quem está nele será respawnado.");
				for(new i; i < GetMaxPlayers(); i++){
					if(IsPlayerConnected(i)){
						if(NoEvento[i] == 1) {
							SpawnPlayer(i);
							GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~r~EVENTO ENCERRADO!", 5000, 5);
						}
					}
				}
				DestroyObject(MTAREA51[0]);
				DestroyObject(MTAREA51[1]);
				DestroyObject(MTAREA51[2]);
				DestroyObject(MTAREA51[3]);
				DestroyObject(MTAREA51[4]);
				DestroyObject(ESCMLS);
				DestroyObject(ESCMDLS[0]);
				DestroyObject(ESCMDLS[1]);
				DestroyObject(ESCCF);
				DestroyObject(SKYFALL);
				EventoSkyFall = false;
				DestroyObject(CorridaCC);
				DestroyObject(CorridaLV);
				EventoCorridaCC = false;
				EventoCorridaLV = false;
			}
		}
		if(listitem == 4){ //MORTO VIVO AREA 51
            if(EventoAtivo == 0){
				SetPlayerPos(playerid, 214.1309,1866.9543,13.1406);
				SetPlayerFacingAngle(playerid, 179.9621);
				SetCameraBehindPlayer(playerid);
				GivePlayerWeapon(playerid, 38, 99999);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 1000);

				evento_x = 214.1309;
				evento_y = 1866.9543;
				evento_z = 13.1406;
				evento_f = 179.9621;

   				evento_vw = 1000;
				evento_in = 0;

				EventoAtivo = 1;
				EventoAdminID = playerid;
				EventoPausado = 1;
				if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) EventoOHK = false;
   				SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Evento ativado. Digite /eventoliberar para liberá-lo!");

   				EventoNome = "MORTO-VIVO (AREA51)";
				EventoSPA = false;
				EventoSemDanos = true;
				EventoOHK = false;
				EventoRecarregarLife = false;
				EventoKitWalk = false;
				EventoKitRun = false;
				EventoProibirTele = true;
				EventoDarColete = 0;
				EventoDarLife = 0;
				EventoDarVeiculoID = 0;
				EventoDarArmaID = 0;
				EventoVeiculos = 0;
				EventoCarregar = 0;
				EventoDesarmar = 1;
				EventoGranadas = 0;
				EventoProibirCS = 1;
				EventoProibirGC = 0;
				EventoProibirFlip = 0;
				EventoMatarAoSairVeiculo = 0;
				MTAREA51[0] = 	CreateObject(2669, 227.91579, 1873.81677, 13.64500,   0.00000, 0.00000, 0.00000);
				MTAREA51[1] = 	CreateObject(2669, 211.88855, 1876.40625, 13.09900,   0.00000, 0.00000, 91.00000);
				MTAREA51[2] = 	CreateObject(2669, 216.46887, 1876.49170, 13.09900,   0.00000, 0.00000, 91.00000);
				MTAREA51[3] = 	CreateObject(2669, 216.21060, 1876.46155, 15.64700,   0.00000, 0.00000, 91.00000);
				MTAREA51[4] = 	CreateObject(2669, 212.29285, 1876.39209, 15.64700,   0.00000, 0.00000, 91.00000);
			}else{
				EventoAtivo = 0;
				EventoAdminID = -1;
				EventoNome = "";
				SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Evento desativado, quem está nele será respawnado.");
				for(new i; i < GetMaxPlayers(); i++){
					if(IsPlayerConnected(i)){
						if(NoEvento[i] == 1) {
							SpawnPlayer(i);
							GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~r~EVENTO ENCERRADO!", 5000, 5);
						}
					}
				}
				DestroyObject(MTAREA51[0]);
				DestroyObject(MTAREA51[1]);
				DestroyObject(MTAREA51[2]);
				DestroyObject(MTAREA51[3]);
				DestroyObject(MTAREA51[4]);
				DestroyObject(ESCMLS);
				DestroyObject(ESCMDLS[0]);
				DestroyObject(ESCMDLS[1]);
				DestroyObject(ESCCF);
				DestroyObject(SKYFALL);
				EventoSkyFall = false;
				DestroyObject(CorridaCC);
				DestroyObject(CorridaLV);
				EventoCorridaCC = false;
				EventoCorridaLV = false;

			}
		}
		if(listitem == 5){ //SURF NO AVIAO AEROLS
            if(EventoAtivo == 0){
				SetPlayerPos(playerid, 1936.9506,-2260.2490,13.5469);
				SetPlayerFacingAngle(playerid, 180.2809);
				SetCameraBehindPlayer(playerid);
				GivePlayerWeapon(playerid, 38, 99999);

				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 1000);

				evento_x = 1936.9506;
				evento_y = -2260.2490;
				evento_z = 13.5469;
				evento_f = 180.2809;

   				evento_vw = 1000;
				evento_in = 0;

				EventoAtivo = 1;
				EventoAdminID = playerid;
				EventoPausado = 1;
				if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) EventoOHK = false;
   				SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Evento ativado. Digite /eventoliberar para liberá-lo!");

   				EventoNome = "SURF (AEROLS)";
				EventoSPA = false;
				EventoSemDanos = true;
				EventoOHK = false;
				EventoRecarregarLife = false;
				EventoKitWalk = false;
				EventoKitRun = false;
				EventoProibirTele = true;
				EventoDarColete = 0;
				EventoDarLife = 0;
				EventoDarVeiculoID = 0;
				EventoDarArmaID = 0;
				EventoVeiculos = 0;
				EventoCarregar = 0;
				EventoDesarmar = 1;
				EventoGranadas = 0;
				EventoProibirCS = 1;
				EventoProibirGC = 0;
				EventoProibirFlip = 0;
				EventoMatarAoSairVeiculo = 0;
			}else{
				EventoAtivo = 0;
				EventoAdminID = -1;
				EventoNome = "";
				SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Evento desativado, quem está nele será respawnado.");
				for(new i; i < GetMaxPlayers(); i++){
					if(IsPlayerConnected(i)){
						if(NoEvento[i] == 1) {
							SpawnPlayer(i);
							GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~r~EVENTO ENCERRADO!", 5000, 5);
						}
					}
				}
				DestroyObject(MTAREA51[0]);
				DestroyObject(MTAREA51[1]);
				DestroyObject(MTAREA51[2]);
				DestroyObject(MTAREA51[3]);
				DestroyObject(MTAREA51[4]);
				DestroyObject(ESCMLS);
				DestroyObject(ESCMDLS[0]);
				DestroyObject(ESCMDLS[1]);
				DestroyObject(ESCCF);
				DestroyObject(SKYFALL);
				EventoSkyFall = false;
				DestroyObject(CorridaCC);
				DestroyObject(CorridaLV);
				EventoCorridaCC = false;
				EventoCorridaLV = false;
			}
		}
		if(listitem == 6){ //CORRIDA NO LV
			EventoCorridaLV = true;
            if(EventoAtivo == 0){
				SetPlayerPos(playerid, 2066.1233,843.0891,6.7031);
				SetPlayerFacingAngle(playerid, 88.5194);
				SetCameraBehindPlayer(playerid);
				GivePlayerWeapon(playerid, 38, 99999);

				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 1000);

				evento_x = 2066.1233;
				evento_y = 843.0891;
				evento_z = 6.7031;
				evento_f = 88.5194;

   				evento_vw = 1000;
				evento_in = 0;

				EventoAtivo = 1;
				EventoAdminID = playerid;
				EventoPausado = 1;
				if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) EventoOHK = false;
   				SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Evento ativado. Digite /eventoliberar para liberá-lo!");

   				EventoNome = "CORRIDA (LV)";
   				EventoDarSpeed = 0;
				EventoSPA = false;
				EventoSemDanos = false;
				EventoOHK = false;
				EventoRecarregarLife = false;
				EventoKitWalk = false;
				EventoKitRun = false;
				EventoProibirTele = true;
				EventoDarColete = 0;
				EventoDarLife = 0;
				EventoDarVeiculoID = 411;
				EventoDarArmaID = 0;
				EventoVeiculos = 0;
				EventoCarregar = 0;
				EventoDesarmar = 1;
				EventoGranadas = 0;
				EventoProibirCS = 1;
				EventoProibirGC = 0;
				EventoProibirFlip = 0;
				EventoMatarAoSairVeiculo = 1;
				CorridaLV = CreateObject(18844, 2067.84399, 842.12543, 5.72530,   0.00000, 0.00000, 0.00000);
			}else{
				EventoAtivo = 0;
				EventoAdminID = -1;
				EventoNome = "";
				SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Evento desativado, quem está nele será respawnado.");
				for(new i; i < GetMaxPlayers(); i++){
					if(IsPlayerConnected(i)){
						if(NoEvento[i] == 1) {
							SpawnPlayer(i);
							GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~r~EVENTO ENCERRADO!", 5000, 5);
						}
					}
				}
				DestroyObject(MTAREA51[0]);
				DestroyObject(MTAREA51[1]);
				DestroyObject(MTAREA51[2]);
				DestroyObject(MTAREA51[3]);
				DestroyObject(MTAREA51[4]);
				DestroyObject(ESCMLS);
				DestroyObject(ESCMDLS[0]);
				DestroyObject(ESCMDLS[1]);
				DestroyObject(ESCCF);
				DestroyObject(SKYFALL);
				EventoSkyFall = false;
				DestroyObject(CorridaCC);
				DestroyObject(CorridaLV);
				EventoCorridaCC = false;
				EventoCorridaLV = false;
			}
		}
		if(listitem == 7){ //CORRIDA NO CC
            if(EventoAtivo == 0){
                EventoCorridaCC = true;
				SetPlayerPos(playerid, 3097.3650,-1814.6003,13.0507);
				SetPlayerFacingAngle(playerid, 176.9405);
				SetCameraBehindPlayer(playerid);
				GivePlayerWeapon(playerid, 38, 99999);

				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 1000);

				evento_x = 3097.3650;
				evento_y = -1814.6003;
				evento_z = 13.0507;
				evento_f = 176.9405;

   				evento_vw = 1000;
				evento_in = 0;

				EventoAtivo = 1;
				EventoAdminID = playerid;
				EventoPausado = 1;
				if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) EventoOHK = false;
   				SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Evento ativado. Digite /eventoliberar para liberá-lo!");

   				EventoNome = "CORRIDA (CC)";
   				EventoDarSpeed = 0;
				EventoSPA = false;
				EventoSemDanos = false;
				EventoOHK = false;
				EventoRecarregarLife = false;
				EventoKitWalk = false;
				EventoKitRun = false;
				EventoProibirTele = true;
				EventoDarColete = 0;
				EventoDarLife = 0;
				EventoDarVeiculoID = 411;
				EventoDarArmaID = 0;
				EventoVeiculos = 0;
				EventoCarregar = 0;
				EventoDesarmar = 1;
				EventoGranadas = 0;
				EventoProibirCS = 1;
				EventoProibirGC = 0;
				EventoProibirFlip = 0;
				EventoMatarAoSairVeiculo = 1;
				CorridaCC = CreateObject(18844, 3097.36499, -1814.60034, 13.05070,   0.00000, 0.00000, 0.00000);
			}else{
				EventoAtivo = 0;
				EventoAdminID = -1;
				EventoNome = "";
				SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Evento desativado, quem está nele será respawnado.");
				for(new i; i < GetMaxPlayers(); i++){
					if(IsPlayerConnected(i)){
						if(NoEvento[i] == 1) {
							SpawnPlayer(i);
							GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~r~EVENTO ENCERRADO!", 5000, 5);
						}
					}
				}
				DestroyObject(MTAREA51[0]);
				DestroyObject(MTAREA51[1]);
				DestroyObject(MTAREA51[2]);
				DestroyObject(MTAREA51[3]);
				DestroyObject(MTAREA51[4]);
				DestroyObject(ESCMLS);
				DestroyObject(ESCMDLS[0]);
				DestroyObject(ESCMDLS[1]);
				DestroyObject(ESCCF);
				DestroyObject(SKYFALL);
				EventoSkyFall = false;
				DestroyObject(CorridaCC);
				DestroyObject(CorridaLV);
				EventoCorridaCC = false;
				EventoCorridaLV = false;
			}
		}
    }
	return 1;
}

//XENON
if(dialogid == XenonDialog){
	if(response){
			if(listitem == 0){
				if(Xenon[playerid] == 1) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: O seu veículo já possui Xenon, remova este para adicionar outro!");
				Xenons[playerid][0] = CreateObject(19298,0,0,0,0,0,0);
				Xenons[playerid][1] = CreateObject(19298,0,0,0,0,0,0);
				AttachObjectToVehicle(Xenons[playerid][0], GetPlayerVehicleID(playerid), 0.679999, 3.315028, -0.234999, 0.000000, 0.000000, -88.589958);
				AttachObjectToVehicle(Xenons[playerid][1], GetPlayerVehicleID(playerid), -0.729999, 3.315028, -0.234999, 0.000000, 0.000000, -88.589958);
				GameTextForPlayer(playerid,"~b~~h~XENON AZUL~n~~b~~h~ADICIONADO",2000,3);
				Xenon[playerid]=1;
    			XenonVerifica[playerid] = 0;
				XenonContagem++;
				XenonContagem++;
			}
			if(listitem == 1){
				if(Xenon[playerid] == 1) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: O seu veículo já possui Xenon, remova este para adicionar outro!");
				Xenons[playerid][2] = CreateObject(19297,0,0,0,0,0,0);
				Xenons[playerid][3] = CreateObject(19297,0,0,0,0,0,0);
				AttachObjectToVehicle(Xenons[playerid][2], GetPlayerVehicleID(playerid), 0.679999, 3.315028, -0.234999, 0.000000, 0.000000, -88.589958);
				AttachObjectToVehicle(Xenons[playerid][3], GetPlayerVehicleID(playerid), -0.729999, 3.315028, -0.234999, 0.000000, 0.000000, -88.589958);
				GameTextForPlayer(playerid,"~g~~h~XENON VERDE~n~~g~~h~ADICIONADO",2000,3);
				Xenon[playerid]=1;
				XenonVerifica[playerid] = 1;
				XenonContagem++;
				XenonContagem++;
 			}
			if(listitem == 2){
				if(Xenon[playerid] == 1) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: O seu veículo já possui Xenon, remova este para adicionar outro!");
				Xenons[playerid][4] = CreateObject(19295,0,0,0,0,0,0);
				Xenons[playerid][5] = CreateObject(19295,0,0,0,0,0,0);
				AttachObjectToVehicle(Xenons[playerid][4], GetPlayerVehicleID(playerid), 0.679999, 3.315028, -0.234999, 0.000000, 0.000000, -88.589958);
				AttachObjectToVehicle(Xenons[playerid][5], GetPlayerVehicleID(playerid), -0.729999, 3.315028, -0.234999, 0.000000, 0.000000, -88.589958);
				GameTextForPlayer(playerid,"~w~~h~XENON BRANCO~n~~w~~h~ADICIONADO",2000,3);
				Xenon[playerid]=1;
				XenonVerifica[playerid] = 2;
				XenonContagem++;
				XenonContagem++;
			}
			if(listitem == 3){
				if(Xenon[playerid] == 1) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: O seu veículo já possui Xenon, remova este para adicionar outro!");
				Xenons[playerid][6] = CreateObject(19296,0,0,0,0,0,0);
				Xenons[playerid][7] = CreateObject(19296,0,0,0,0,0,0);
				AttachObjectToVehicle(Xenons[playerid][6], GetPlayerVehicleID(playerid), 0.679999, 3.315028, -0.234999, 0.000000, 0.000000, -88.589958);
				AttachObjectToVehicle(Xenons[playerid][7], GetPlayerVehicleID(playerid), -0.729999, 3.315028, -0.234999, 0.000000, 0.000000, -88.589958);
				GameTextForPlayer(playerid,"~r~~h~XENON VERMELHO~n~~r~~h~ADICIONADO",2000,3);
				Xenon[playerid]=1;
				XenonVerifica[playerid] = 3;
				XenonContagem++;
				XenonContagem++;
			}
			if(listitem == 4){
				if(Xenon[playerid] == 1) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: O seu veículo já possui Xenon, remova este para adicionar outro!");
				Xenons[playerid][8] = CreateObject(19297,0,0,0,0,0,0);
				Xenons[playerid][9] = CreateObject(19297,0,0,0,0,0,0);
				AttachObjectToVehicle(Xenons[playerid][8], GetPlayerVehicleID(playerid), 0.679999, 3.315028, -0.234999, 0.000000, 0.000000, -88.589958);
				AttachObjectToVehicle(Xenons[playerid][9], GetPlayerVehicleID(playerid), -0.729999, 3.315028, -0.234999, 0.000000, 0.000000, -88.589958);

				Xenons[playerid][10] = CreateObject(19296,0,0,0,0,0,0);
				Xenons[playerid][11] = CreateObject(19296,0,0,0,0,0,0);
				AttachObjectToVehicle(Xenons[playerid][10], GetPlayerVehicleID(playerid), 0.679999, 3.315028, -0.234999, 0.000000, 0.000000, -88.589958);
				AttachObjectToVehicle(Xenons[playerid][11], GetPlayerVehicleID(playerid), -0.729999, 3.315028, -0.234999, 0.000000, 0.000000, -88.589958);

				GameTextForPlayer(playerid,"~h~XENON AMARELO~h~~n~ADICIONADO",2000,3);
				Xenon[playerid]=1;
				XenonVerifica[playerid] = 4;
				XenonContagem++;
				XenonContagem++;
				XenonContagem++;
				XenonContagem++;
			}
			if(listitem == 5){
				if(Xenon[playerid] == 1) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: O seu veículo já possui Xenon, remova este para adicionar outro!");
				Xenons[playerid][12] = CreateObject(19296,0,0,0,0,0,0);
				Xenons[playerid][13] = CreateObject(19296,0,0,0,0,0,0);

				AttachObjectToVehicle(Xenons[playerid][12], GetPlayerVehicleID(playerid), 0.679999, 3.315028, -0.234999, 0.000000, 0.000000, -88.589958);
				AttachObjectToVehicle(Xenons[playerid][13], GetPlayerVehicleID(playerid), -0.729999, 3.315028, -0.234999, 0.000000, 0.000000, -88.589958);

				Xenons[playerid][14] = CreateObject(19298,0,0,0,0,0,0);
				Xenons[playerid][15] = CreateObject(19298,0,0,0,0,0,0);

				AttachObjectToVehicle(Xenons[playerid][14], GetPlayerVehicleID(playerid), 0.679999, 3.315028, -0.234999, 0.000000, 0.000000, -88.589958);
				AttachObjectToVehicle(Xenons[playerid][15], GetPlayerVehicleID(playerid), -0.729999, 3.315028, -0.234999, 0.000000, 0.000000, -88.589958);
				GameTextForPlayer(playerid,"~r~~h~~h~~h~XENON ROSA~n~~r~~h~~h~~h~ADICIONADO",2000,3);
				Xenon[playerid]=1;
				XenonVerifica[playerid] = 5;
				XenonContagem++;
				XenonContagem++;
				XenonContagem++;
				XenonContagem++;
			}
			if(listitem == 6){
			if(Xenon[playerid] == 1) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: O seu veículo já possui Xenon, remova este para adicionar outro!");
				Xenons[playerid][16] = CreateObject(19297,0,0,0,0,0,0);
				Xenons[playerid][17] = CreateObject(19297,0,0,0,0,0,0);

				AttachObjectToVehicle(Xenons[playerid][16], GetPlayerVehicleID(playerid), 0.679999, 3.315028, -0.234999, 0.000000, 0.000000, -88.589958);
				AttachObjectToVehicle(Xenons[playerid][17], GetPlayerVehicleID(playerid), -0.729999, 3.315028, -0.234999, 0.000000, 0.000000, -88.589958);

				Xenons[playerid][18] = CreateObject(19298,0,0,0,0,0,0);
				Xenons[playerid][19] = CreateObject(19298,0,0,0,0,0,0);

				AttachObjectToVehicle(Xenons[playerid][18], GetPlayerVehicleID(playerid), 0.679999, 3.315028, -0.234999, 0.000000, 0.000000, -88.589958);
				AttachObjectToVehicle(Xenons[playerid][19], GetPlayerVehicleID(playerid), -0.729999, 3.315028, -0.234999, 0.000000, 0.000000, -88.589958);
				GameTextForPlayer(playerid,"~b~~h~~h~~h~XENON VERDE CLARO~n~~b~~h~~h~~h~ADICIONADO",2000,3);
				Xenon[playerid]=1;
				XenonVerifica[playerid] = 6;
				XenonContagem++;
				XenonContagem++;
				XenonContagem++;
				XenonContagem++;
			}
			if(listitem == 7){
			if(Xenon[playerid] == 0) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não adicionar um xenon agora!");
				if(Xenon[playerid] == 1){
					if(XenonVerifica[playerid] == 0){
							DestroyObject(Xenons[playerid][0]);
							DestroyObject(Xenons[playerid][1]);
							XenonContagem--;
							XenonContagem--;
					}
					if(XenonVerifica[playerid] == 1){
							DestroyObject(Xenons[playerid][2]);
							DestroyObject(Xenons[playerid][3]);
							XenonContagem--;
							XenonContagem--;
					}
					if(XenonVerifica[playerid] == 2){
							DestroyObject(Xenons[playerid][4]);
							DestroyObject(Xenons[playerid][5]);
							XenonContagem--;
							XenonContagem--;
					}
					if(XenonVerifica[playerid] == 3){
							DestroyObject(Xenons[playerid][6]);
							DestroyObject(Xenons[playerid][7]);
							XenonContagem--;
							XenonContagem--;
					}
					if(XenonVerifica[playerid] == 4){
							DestroyObject(Xenons[playerid][8]);
							DestroyObject(Xenons[playerid][9]);
							DestroyObject(Xenons[playerid][10]);
							DestroyObject(Xenons[playerid][11]);
							XenonContagem--;
							XenonContagem--;
							XenonContagem--;
							XenonContagem--;
					}
			  		if(XenonVerifica[playerid] == 5){
							DestroyObject(Xenons[playerid][12]);
							DestroyObject(Xenons[playerid][13]);
							DestroyObject(Xenons[playerid][14]);
							DestroyObject(Xenons[playerid][15]);
							XenonContagem--;
							XenonContagem--;
							XenonContagem--;
							XenonContagem--;
					}
					if(XenonVerifica[playerid] == 6){
							DestroyObject(Xenons[playerid][16]);
							DestroyObject(Xenons[playerid][17]);
							DestroyObject(Xenons[playerid][18]);
							DestroyObject(Xenons[playerid][19]);
							XenonContagem--;
							XenonContagem--;
							XenonContagem--;
							XenonContagem--;
					}
				Xenon[playerid]=0;
  				GameTextForPlayer(playerid,"~w~~h~~h~XENON REMOVIDO COM SUCESSO",2000,3);
			}
	}
}
return 1;
}


if(dialogid == 9604)  //Menu de Radios 2
{
    if(!response) return ShowRadiosForPlayer(playerid);


	if(listitem == 0)
    {
    SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: A reprodução de rádios ou sons web foi parada");
    StopAudioStreamForPlayer(playerid);
    OuvindoRadio[playerid] = false;
    return 1;
    }

	if(listitem == 1)
    {
    PlayAudioStreamForPlayer(playerid, "http://streaming.shoutcast.com/RadioHunter-TheHitzChannel");
    SendClientMessage(playerid, COLOUR_INFORMACAO, ">> Se não estiver ouvindo, verifique se o volume da rádio nas opções do jogo está correto!");
    SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Rádio selecionada: {FFFFFF}Radio Hunter");
    OuvindoRadio[playerid] = true;
    return 1;
    }

	if(listitem == 2)
    {
    PlayAudioStreamForPlayer(playerid, "http://streaming.shoutcast.com/89FMARADIOROCK?lang=pt-BR%2cpt%3bq%3d0.8%2cen-US%3bq%3d0.6%2cen%3bq%3d0.4");
    SendClientMessage(playerid, COLOUR_INFORMACAO, ">> Se não estiver ouvindo, verifique se o volume da rádio nas opções do jogo está correto!");
    SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Rádio selecionada: {FFFFFF}Rock");
    OuvindoRadio[playerid] = true;
    return 1;
    }

    if(listitem == 3)
    {
    PlayAudioStreamForPlayer(playerid, "http://ledjamradio.ice.infomaniak.ch/ledjamradio.mp3?lang=pt-BR%2cpt%3bq%3d0.8%2cen-US%3bq%3d0.6%2cen%3bq%3d0.4");
    SendClientMessage(playerid, COLOUR_INFORMACAO, ">> Se não estiver ouvindo, verifique se o volume da rádio nas opções do jogo está correto!");
    SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Rádio selecionada: {FFFFFF}Reggae");
    OuvindoRadio[playerid] = true;
    return 1;
    }

   /* if(listitem == 3)
    {
    PlayAudioStreamForPlayer(playerid, "http://dl.dropboxusercontent.com/s/xpgtgubdt9nvblr/MC%20Pikachu%20-%20Ela%20e%20Profissional.mp3");
    SendClientMessage(playerid, COLOUR_INFORMACAO, ">> Se não estiver ouvindo, verifique se o volume da rádio nas opções do jogo está correto!");
    SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Rádio selecionada: {FFFFFF}MC Pikachu - Ela e Profissional");
    OuvindoRadio[playerid] = true;
    return 1;
    }

    if(listitem == 4)
    {
    PlayAudioStreamForPlayer(playerid, "http://dl.dropboxusercontent.com/s/m9uf80gwyhd470x/MC%20Melqui%20-%20Se%20Joga.mp3");
    SendClientMessage(playerid, COLOUR_INFORMACAO, ">> Se não estiver ouvindo, verifique se o volume da rádio nas opções do jogo está correto!");
    SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Rádio selecionada: {FFFFFF}MC Melqui - Se Joga");
    OuvindoRadio[playerid] = true;
    return 1;
    }

    if(listitem == 5)
    {
    PlayAudioStreamForPlayer(playerid, "http://dl.dropboxusercontent.com/s/188c6owh4igwq6l/MC%20Taz%20-%20O%20filho%20do%20dono.mp3");
    SendClientMessage(playerid, COLOUR_INFORMACAO, ">> Se não estiver ouvindo, verifique se o volume da rádio nas opções do jogo está correto!");
    SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Rádio selecionada: {FFFFFF}MC Taz - O filho do dono");
    OuvindoRadio[playerid] = true;
    return 1;
    }*/

}

if(dialogid == 9602)  //Menu do Tela3
{
    if(!response) return 1;
    if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não possui permissão para isso");

    if(listitem == 0)
	{
	if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não possui permissão para isso");
	CallRemoteFunction("CMDMessageToAdmins","is",playerid,"TELA3");
	Tela3Set(1," ",1);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: TELA3 limpo!");
  	return 1;
	}

    if(listitem == 1)
	{
	CallRemoteFunction("CMDMessageToAdmins","is",playerid,"TELA3");
	new string[100];
	format(string, sizeof(string), "~w~GRANAFACIL AMMU ~g~/LV~n~~w~VALENDO: ~y~$%i~n~~w~POR SEGUNDO!", GranaFacilValor);
	Tela3Set(30,string,1);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Anunciando Grana Fácil!");
  	return 1;
	}

 	if(listitem == 2)
	{
	if(CallRemoteFunction("GetBarStatus","i",playerid) == 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O Bar não está aberto!");
	CallRemoteFunction("CMDMessageToAdmins","is",playerid,"TELA3");
	Tela3Set(30,"~w~Colete, Life e Jetpack~n~Aberto:~r~ /BAR",1);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Anunciando Bar!");
  	return 1;
	}

	if(listitem == 3)
	{
	if(EventoAtivo == 0 || EventoPausado == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O Evento não está disponível!");
	CallRemoteFunction("CMDMessageToAdmins","is",playerid,"TELA3");
	new EventoShow[100];
	format(EventoShow, sizeof(EventoShow), "~r~/EVENTO~n~~y~%s~n~~w~Venham todos!", EventoNome);
	Tela3Set(30,EventoShow,1);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Anunciando Evento!");
  	return 1;
	}

	if(listitem == 4)
	{
	if(Neons > 16) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Ao menos duas vagas de neon são necessárias!");
	CallRemoteFunction("CMDMessageToAdmins","is",playerid,"TELA3");
	new string[100];
	format(string, sizeof(string), "~r~Corra galera!~n~~g~Vagas de Neon: ~w~%i", (20-Neons) /2 );
	Tela3Set(6,string,1);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Anunciando Vagas de Neon!");
  	return 1;
	}

    if(listitem == 5)
	{
	CallRemoteFunction("CMDMessageToAdmins","is",playerid,"TELA3");
	new string[100];
	format(string, sizeof(string), "~y~HACKS/DB ~g~USE ~y~~n~/REPORT ID MOTIVO");
	Tela3Set(30,string,1);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Anunciando na tela!");
  	return 1;
	}

	if(listitem == 6)
	{
	CallRemoteFunction("CMDMessageToAdmins","is",playerid,"TELA3");
	new string[100];
	format(string, sizeof(string), "~y~Para deixar seu jogo mais leve ~n~~g~USE: ~b~/TXOFF /SL");
	Tela3Set(30,string,1);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Anunciando na tela!");
  	return 1;
	}

	return 1;
}



if(dialogid == 9601)  //Menu de Neons
{
    if(!response) return 1;
    if(listitem == 0) return DestroyNeons(playerid,true);

	if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5){
	if(Neons >= 20) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Limite de 10 veículos com neon alcançado. Tente novamente mais tarde");}

    if(veiculo[playerid] == 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não tem veículo próprio, escolha um: /CS");
    if(IsABike(veiculo[playerid])) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Veículo impróprio para a instalação de neon");
    if(listitem == 1) return AddNeons(playerid,1,18647);
    if(listitem == 2) return AddNeons(playerid,1,18648);
    if(listitem == 3) return AddNeons(playerid,1,18649);
    if(listitem == 4) return AddNeons(playerid,1,18650);
    if(listitem == 5) return AddNeons(playerid,1,18651);
    if(listitem == 6) return AddNeons(playerid,1,18652);
    if(listitem == 7) {if(GetVehicleModel(veiculo[playerid]) != 411) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Giroflex somente pode ser acoplado no Infernus");else AddNeons(playerid,2,18646);}return 1;
}

if(dialogid == 9559)  //Voltar ao menu de Rankings
{
    if(!response) MostrarMenuRanks(playerid);
	return 1;
}


if(dialogid == 9600) //RANKINGS
{
	if(!response){return 1;}
	if(listitem == 0) ShowTopTenKillsForPlayer(playerid);
	if(listitem == 1) ShowTopTenScoreForPlayer(playerid);
	if(listitem == 2) ShowTopTenSpreeForPlayer(playerid);
	if(listitem == 3) ShowTopTenDinheiroForPlayer(playerid);
	if(listitem == 4) ShowReisForPlayer(playerid,9559);
	return 1;
}


if(dialogid == 987) //EFEITOS
{
	if(!response){return 1;}
	if(!IsPlayerSpawned(playerid)){return 1;}
	if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
	if(Arena2[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
	if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
	if(listitem == 0){if(IsPlayerAttachedObjectSlotUsed(playerid,2)){RemovePlayerAttachedObject(playerid,2);SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Efeito removido");}return 1;}
	if(listitem == 1){SetPlayerAttachedObject(playerid,2, 18690, 1, -0.8, 0.0, -0.3, 0.0, 87.0, 90.0);}
	if(listitem == 2){SetPlayerAttachedObject(playerid,2, 18714, 1, -0.2, 0.1, 0.0, 0.0, 87.0, 90.0);}
	if(listitem == 3){SetPlayerAttachedObject(playerid,2, 18720, 1, -0.2, 0.1, 0.0, 0.0, 87.0, 90.0);}
	if(listitem == 4){SetPlayerAttachedObject(playerid,2, 18721, 1, -0.2, 0.1, 0.0, 0.0, 87.0, 90.0);}
	if(listitem == 5){SetPlayerAttachedObject(playerid,2, 18728, 1, -0.2, 0.1, 0.0, 0.0, 87.0, 90.0);}
	if(listitem == 6){SetPlayerAttachedObject(playerid,2, 18742, 1, -0.2, 0.1, 0.0, 0.0, 87.0, 90.0);}
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Espero que goste do novo efeito!");
	return 1;
}


if(dialogid == 988) //Pintura Personalizada
{
	if(!response){return 1;}
	if(GetPlayerVehicleID(playerid) != veiculo[playerid]){SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve estar em seu veículo feito pelo /CS"); return 1;}
	if(veiculo[playerid] == 0){SendClientMessage(playerid, COLOUR_ERRO, "ERRO: Você não tem veículo próprio, escolha um: /CS"); return 1;}
	if(strlen(inputtext) == 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não digitou nada");
	if(strlen(inputtext) > 10) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: A placa deve ter no máximo 10 caracteres");
	SetVehicleNumberPlate(veiculo[playerid],inputtext);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Alterando placa...");
	ResyncVeiculo(playerid);
	return 1;
}


if(dialogid == 989) //Veiculos
{
	if(!response){return 1;}
	if(veiculo[playerid] == 0){SendClientMessage(playerid, COLOUR_ERRO, "ERRO: Você não tem veículo próprio, escolha um: /CS"); return 1;}

	if(listitem == 0){
	if(MotorLigado(veiculo[playerid]) == 1){
	MotorLigar(veiculo[playerid]);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Motor ligado!");
	return 1;}else{
	MotorDesligar(veiculo[playerid]);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Motor desligado!");
	return 1;}}

	if(listitem == 1){
	if(FaroisLigados(veiculo[playerid]) == 1){
	FaroisLigar(veiculo[playerid]);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Faróis ligados!");
	return 1;}else{
	FaroisDesligar(veiculo[playerid]);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Faróis desligados!");
	return 1;}}

	if(listitem == 2){
	if(AlarmeLigado(veiculo[playerid]) == 1){
	AlarmeLigar(veiculo[playerid]);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Alarme ligado!");
	return 1;}else{
	AlarmeDesligar(veiculo[playerid]);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Alarme desligado!");
	return 1;}}

	if(listitem == 3){
	if(CapoAberto(veiculo[playerid]) == 1){
	CapoAbrir(veiculo[playerid]);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Capo aberto!");
	return 1;}else{
	CapoFechar(veiculo[playerid]);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Capo fechado!");
	return 1;}}

	if(listitem == 4){
	if(MalaAberta(veiculo[playerid]) == 1){
	MalaAbrir(veiculo[playerid]);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Porta-malas aberto!");
	return 1;}else{
	MalaFechar(veiculo[playerid]);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Porta-malas fechado!");
	return 1;}}

	if(listitem == 5){
	if(GetPlayerVehicleID(playerid) != veiculo[playerid]){SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve estar em seu veículo feito pelo /CS"); return 1;}
	ShowPlayerDialog(playerid,988,DIALOG_STYLE_INPUT,"Placa personalizada","Digite abaixo um nome personalizado\npara a placa de seu veículo!\n","Emplacar","Cancelar");
	return 1;}

	if(listitem == 6){
	if(PiscarLuzes[playerid] == true){
	PiscarLuzes[playerid] = false;
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Faróis piscando desligado!");return 1;}else{
	PiscarLuzes[playerid] = true;
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Faróis piscando ligado!");return 1;}}

	return 1;
}


if(dialogid == 990) //CANCELAR SL
{
	if(response){return 1;}
	XuxaPC[playerid] = 0;
	SetPlayerWeather(playerid, Weather[playerid]);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Clima restaurado!");
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Modo lag baixo desativado!");
	return 1;
}


if(dialogid == 991) //ESTILOS DE LUTA
{
	if(!response){return 1;}
	if(listitem == 0)SetPlayerFightingStyle(playerid, FIGHT_STYLE_NORMAL);
	if(listitem == 1)SetPlayerFightingStyle(playerid, FIGHT_STYLE_BOXING);
	if(listitem == 2)SetPlayerFightingStyle(playerid, FIGHT_STYLE_KUNGFU);
	if(listitem == 3)SetPlayerFightingStyle(playerid, FIGHT_STYLE_KNEEHEAD);
	if(listitem == 4)SetPlayerFightingStyle(playerid, FIGHT_STYLE_GRABKICK);
	if(listitem == 5)SetPlayerFightingStyle(playerid, FIGHT_STYLE_ELBOW);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Estilo de luta modificado!");
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Para bater com o novo estilo, pressione MOUSE B. DIREITO + ENTER");
	return 1;
}

if(dialogid == 992) //ANIMS E AÇÕES
{
	if(!response){return 1;}
	if(listitem == 0)SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1);
	if(listitem == 1)SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE2);
	if(listitem == 2)SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE3);
	if(listitem == 3)SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE4);
	if(listitem == 4)SetPlayerSpecialAction(playerid, SPECIAL_ACTION_HANDSUP);
	if(listitem == 5)SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
	if(listitem == 6)SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
	if(listitem == 7)SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);
	if(listitem == 8)SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
	if(listitem == 9)SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE);
	if(listitem == 10)SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Ação especial do SKIN aplicada! Pressione F para cancelar.");
	return 1;
}

if(dialogid == 993) //MUNDO DA GUERRA
{
	if(!response){return 1;}
	if(!IsPlayerSpawned(playerid)){return 1;}
	//if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
	if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
	if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
	if(Arena2[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
	Arena[playerid] = 1;
	ArenaTipo[playerid] = 9;
	if(listitem == 0){new rand = random(sizeof(MDSpawns_AEROAB));
	SetPlayerPos(playerid, MDSpawns_AEROAB[rand][0], MDSpawns_AEROAB[rand][1], MDSpawns_AEROAB[rand][2]);
	SetPlayerFacingAngle(playerid,MDSpawns_AEROAB[rand][3]);}
	if(listitem == 1){new rand = random(sizeof(MDSpawns_A51));
	SetPlayerPos(playerid, MDSpawns_A51[rand][0], MDSpawns_A51[rand][1], MDSpawns_A51[rand][2]);
	SetPlayerFacingAngle(playerid,MDSpawns_A51[rand][3]);}
	if(listitem == 2){new rand = random(sizeof(MDSpawns_REST));
	SetPlayerPos(playerid, MDSpawns_REST[rand][0], MDSpawns_REST[rand][1], MDSpawns_REST[rand][2]);
	SetPlayerFacingAngle(playerid,MDSpawns_REST[rand][3]);}
	if(listitem == 3){new rand = random(sizeof(MDSpawns_SD));
	SetPlayerPos(playerid, MDSpawns_SD[rand][0], MDSpawns_SD[rand][1], MDSpawns_SD[rand][2]);
	SetPlayerFacingAngle(playerid,MDSpawns_SD[rand][3]);}
	SetPlayerInterior(playerid,0);
	SetPlayerVirtualWorld(playerid, 18);
	RemoverTodosAttachsObj(playerid);
	SetCameraBehindPlayer(playerid);
	ResetPlayerWeapons(playerid);
	SetPlayerHealth(playerid,100);
	SetPlayerArmour(playerid,100);
	GivePlayerWeapon(playerid, 22, 9999);
	GivePlayerWeapon(playerid, 28, 9999);
	GivePlayerWeapon(playerid, 26, 9999);
	GivePlayerWeapon(playerid, 16, 9999);
	GameTextForPlayer(playerid,"~r~BEM-VINDO A GUERRA!", 5000, 5);
	new pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
	new string[128];
	format(string, sizeof(string), "{FF0000}%s {FFFB00}foi para o MUNDO DA GUERRA. Quem vai?{FF0000}( /MD )", pname);
	SendClientMessageToAll(COLOUR_TELEPORTE, string);
	SendClientMessage(playerid, COLOUR_DICA, "");
	SendClientMessage(playerid, COLOUR_DICA, "SEJA BEM-VINDO AO MUNDO DA GUERRA!");
	SendClientMessage(playerid, COLOUR_DICA, "");
	return 1;
}


if(dialogid == 994) //ANIMS E AÇÕES
{
	if(!response){return 1;}
	if(veiculo[playerid] == 0){SendClientMessage(playerid, COLOUR_ERRO, "ERRO: Você não tem veículo próprio, escolha um: /CS"); return 1;}
	AutoPaintOn[playerid] = 0;
	if(listitem == 0){ChangeVehicleColor(veiculo[playerid], PVA(), PVA());}
	if(listitem == 1){if(AutoPaintOn[playerid] == 1){AutoPaintOn[playerid] = 0;}else{AutoPaintOn[playerid] = 1;}}
	if(listitem == 2){ShowPlayerDialog(playerid,998,DIALOG_STYLE_INPUT,"Pintura personalizada","Digite abaixo as duas ID's de cores\npara pintar seu veículo!\n\nExemplo: 58 25\n\nObtenha ID's no blog do servidor!","Pintar","Cancelar"); return 1;}
	if(listitem == 3){ChangeVehicleColor(veiculo[playerid], 159, 159);}
	if(listitem == 4){ChangeVehicleColor(veiculo[playerid], 152, 152);}
	if(listitem == 5){ChangeVehicleColor(veiculo[playerid], 658, 658);}
	if(listitem == 6){ChangeVehicleColor(veiculo[playerid], 144, 144);}
	if(listitem == 7){ChangeVehicleColor(veiculo[playerid], 237, 237);}
	if(listitem == 8){ChangeVehicleColor(veiculo[playerid], 240, 240);}
	if(listitem == 9){ChangeVehicleColor(veiculo[playerid], 101, 101);}
	if(listitem == 10){ChangeVehicleColor(veiculo[playerid], 121, 121);}
	if(listitem == 11){ChangeVehicleColor(veiculo[playerid], 146, 146);}
	if(listitem == 12){ChangeVehicleColor(veiculo[playerid], 151, 151);}
	if(listitem == 13){ChangeVehicleColor(veiculo[playerid], 147, 147);}
	if(listitem == 14){ChangeVehicleColor(veiculo[playerid], 605, 605);}
	if(listitem == 15){ChangeVehicleColor(veiculo[playerid], 158, 158);}
	if(listitem == 16){ChangeVehicleColor(veiculo[playerid], 152, 152);}
	if(listitem == 17){ChangeVehicleColor(veiculo[playerid], 0, 0);}
	if(listitem == 18){ChangeVehicleColor(veiculo[playerid], 1, 1);}
	if(listitem == 19){ChangeVehicleColor(veiculo[playerid], 161, 161);}
	if(listitem == 20){ChangeVehicleColor(veiculo[playerid], 166, 166);}
	if(listitem == 21){ChangeVehicleColor(veiculo[playerid], 278, 278);}
	if(listitem == 22){ChangeVehicleColor(veiculo[playerid], 288, 288);}
	if(listitem == 23){ChangeVehicleColor(veiculo[playerid], 6, 6);}
	if(listitem == 24){ChangeVehicleColor(veiculo[playerid], 398, 398);}
	if(listitem == 25){ChangeVehicleColor(veiculo[playerid], 638, 638);}
	if(listitem == 26){ChangeVehicleColor(veiculo[playerid], 643, 643);}
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Pintura especial aplicada!");
	return 1;
}


if(dialogid == 995) //HOLDING OBJECTS
{
	if(!response){return 1;}
	if(!IsPlayerSpawned(playerid)){return 1;}
	if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
	if(Arena2[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
	if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
	if(listitem == 0){if(IsPlayerAttachedObjectSlotUsed(playerid,1)){RemovePlayerAttachedObject(playerid,1);SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Acessório removido");}return 1;}
	if(listitem == 1){SetPlayerAttachedObject(playerid,1, 1609, 1, 0.0, 0.0, 0.0, 90.0, 0.0, -90.0);} //TARTARUGA
	if(listitem == 2){SetPlayerAttachedObject(playerid,1, 1244, 1, -0.2, 0.1, 0.0, 0.0, 87.0, 90.0);} //BOMBA DE GASOLINA
	if(listitem == 3){SetPlayerAttachedObject(playerid,1, 1598, 2, 0.2, 0.0, 0.0, 0.0, 0.0, 0.0);} //BOLA
	if(listitem == 4){SetPlayerAttachedObject(playerid,1, 1518, 2, 0.2, 0.0, -0.04, 0.0, 100.0, 180.0);} //TELEVISÃO
	if(listitem == 5){SetPlayerAttachedObject(playerid,1, 1254, 2, 0.1, 0.01, 0.0, 0.0, 90.0, 0.0);} //CAVEIRA
	if(listitem == 6){SetPlayerAttachedObject(playerid,1, 356, 1, -0.2, -0.15, 0.0, 0.0, 24.0, 0.0);} //M4
	if(listitem == 7){SetPlayerAttachedObject(playerid,1, 3028, 1, 0.3, -0.15, -0.03, 0.0, 120, 0.0);} //ESPADA
	if(listitem == 8){SetPlayerAttachedObject(playerid,1, 366, 1, 0.4, -0.25, 0.0, 0.0, 160.0, 0.0);} //EXTINTOR
	if(listitem == 9){SetPlayerAttachedObject(playerid,1, 371, 1, 0.0, -0.175, 0.0, 0.0, 90.0, 0.0);} //PARAQUEDAS (MOCHILA)
	if(listitem == 10){SetPlayerAttachedObject(playerid,1, 1252, 1, 0.1, -0.2, 0.0, 0.0, 90.0, 0.0);} //EXPLOSIVO
	if(listitem == 11){SetPlayerAttachedObject(playerid,1, 2914, 1, 0.0, 0.0, 0.17, 180.0, 90.0, 0.0);} //BANDEIRA VERDE
	if(listitem == 12){SetPlayerAttachedObject(playerid,1, 3131, 1, -0.2, 0.15, 0.0, 0.0, 90.0, 0.0);} //PARAQUEDAS (ABERTO)
	if(listitem == 13){SetPlayerAttachedObject(playerid,1, 354, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);} //CLARIDADE (HYDRA FLARE)
	if(listitem == 14){SetPlayerAttachedObject(playerid,1, 321, 1, -0.24, 0.6, -0.07, 90.0, 0.0, 0.0);} //DILDO FRENTE
	if(listitem == 15){SetPlayerAttachedObject(playerid,1, 323, 1, -0.7, -0.2, 0.0, -90.0, 50.0, 0.0);} //DILDO ATRÁS
	if(listitem == 16){SetPlayerAttachedObject(playerid,1, 1240, 1, 0.15, 0.17, 0.06, 0.0, 90.0, 0.0);} //CORAÇÃO
	if(listitem == 17){MostrarDialogoAcessorios2(playerid);return 1;}
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Espero que goste do novo acessório!");
	return 1;
}

if(dialogid == 996) //HOLDING OBJECTS 2
{
	if(!response){MostrarDialogoAcessorios1(playerid);return 1;}
	if(!IsPlayerSpawned(playerid)){return 1;}
	if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
	if(Arena2[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
	if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
	if(listitem == 0){SetPlayerAttachedObject(playerid,1 ,16442 , 1, 0, 0, 0, 90, 90, 0);}
	if(listitem == 1){SetPlayerAttachedObject(playerid,1 ,2114 , 2, 0.1, 0, 0, 0, 0, 0);}
	if(listitem == 2){SetPlayerAttachedObject(playerid,1 ,322 , 1, -0.1, 0.2, -0.04, 90, 180, 0);}
	if(listitem == 3){SetPlayerAttachedObject(playerid,1 ,1608 , 1, 0, 0, 0, 0, 90, 0);}
	if(listitem == 4){SetPlayerAttachedObject(playerid,1 ,2780 , 2, 0, 0, 0, 0, 90, 180);}
	if(listitem == 5){SetPlayerAttachedObject(playerid,1, 1654, 1,0.1,0.20,0.0,180.0,100.0,0.0);}
	if(listitem == 6){SetPlayerAttachedObject(playerid,1 ,2054 ,2 ,0.1 ,0.03 ,-0.01 ,0 ,90 ,180);}
	if(listitem == 7){SetPlayerAttachedObject(playerid,1 ,2053 ,2 ,0.1 ,0.03 ,-0.01 ,0 ,90 ,180);}
	if(listitem == 8){SetPlayerAttachedObject(playerid,1 ,2052 ,2 ,0.1 ,0.03 ,-0.01 ,0 ,90 ,180);}
	if(listitem == 9){SetPlayerAttachedObject(playerid,1 ,1213 ,2 ,0.16 ,0 ,0 ,0 ,90 ,0);}
	if(listitem == 10){SetPlayerAttachedObject(playerid,1 ,2226 ,5 ,0.4 ,0.04 ,0, 0 ,-90 ,30);}
	if(listitem == 11){SetPlayerAttachedObject(playerid,1 ,1318 ,15 ,0 ,0 ,1 ,0 ,0 ,0);}
	if(listitem == 12){SetPlayerAttachedObject(playerid,1 ,1238 ,2 ,0.4 ,-0.02 ,0.0001 ,0 ,90 ,0);}
	if(listitem == 13){SetPlayerAttachedObject(playerid,1 ,1582 ,5 ,0 ,0 ,-0.16 ,50 ,0 ,10);}
	if(listitem == 14){SetPlayerAttachedObject(playerid,1 ,1644 ,5 ,0.1 ,0.08 ,0 ,55 ,0 ,180);}
	if(listitem == 15){SetPlayerAttachedObject(playerid,1 ,330 ,5 ,0.15 ,0.01 ,0 ,0 ,180 ,0);}
	if(listitem == 16){SetPlayerAttachedObject(playerid,1 ,330 ,5 ,0.15 ,0.01 ,0 ,0 ,180 ,0);}//cube head
	if(listitem == 17){MostrarDialogoAcessorios3(playerid);return 1;}
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Espero que goste do novo acessório!");
	return 1;
}

if(dialogid == 997) //HOLDING OBJECTS 3
{
	if(!response){MostrarDialogoAcessorios2(playerid);return 1;}
	if(!IsPlayerSpawned(playerid)){return 1;}
	if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
	if(Arena2[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
	if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
	if(listitem == 0){SetPlayerAttachedObject(playerid,1 ,1852 ,2 ,0.1 ,0 ,-0.01 ,0 ,15 ,0);} // cube head
	if(listitem == 1){SetPlayerAttachedObject(playerid,1 ,1603 ,2 ,0.3 ,0 ,0 ,0 ,90 ,0);} // jellyfish hat 1
	if(listitem == 2){SetPlayerAttachedObject(playerid,1 ,1602 ,2 ,0.2 ,0 ,0 ,0 ,90 ,0);} // jellyfish hat 2
	if(listitem == 3){SetPlayerAttachedObject(playerid,1 ,1610 ,2 ,0.08 ,0 ,0 ,0 ,90 ,0);} // sand castle hat
	if(listitem == 4){SetPlayerAttachedObject(playerid,1 ,2470 ,2 ,0.1 ,0 ,-0.07 ,35 ,80 ,180);} // plane hat
	if(listitem == 5){SetPlayerAttachedObject(playerid,1 ,2485 ,2 ,0.1 ,0 ,0.05 ,40 ,80 ,180);} // car hat
	if(listitem == 6){SetPlayerAttachedObject(playerid,1 ,2880 ,2 ,0.13 ,-0.1 ,0 ,0 ,10 ,10);} // hamburger hat
	if(listitem == 7){SetPlayerAttachedObject(playerid,1 ,1736 ,2 ,0 ,0 ,0 ,0 ,90 ,180);} // dead deer head(awesome)
	if(listitem == 8){SetPlayerAttachedObject(playerid,1 ,2680 ,15 ,-0.06 ,0 ,0.15 ,100 ,0 ,190);} // chain on neck
	if(listitem == 9){SetPlayerAttachedObject(playerid,1 ,373 , 1, 0.33, -0.029, -0.15, 65, 25, 35);} // armour
	if(listitem == 10){SetPlayerAttachedObject(playerid,1 ,2036 ,15 ,0 ,0.13 ,-0.2 ,90 ,0 ,-50);} // fake sniper on back
	if(listitem == 11){SetPlayerAttachedObject(playerid,1 ,359 ,15 ,-0.02 ,0.08 ,-0.3 ,0 ,50 ,-10);} // rpg on back
	if(listitem == 12){SetPlayerAttachedObject(playerid,1 ,1951 ,5 ,0.13 ,0.09 ,0.05 ,-30 ,190 ,0);} // big green bottle
	if(listitem == 13){SetPlayerAttachedObject(playerid,1 ,1667 ,6 ,0.09 ,0.04 ,0.07 ,170 ,-170 ,0);} // whine glass
	if(listitem == 14){SetPlayerAttachedObject(playerid,1 ,2703 ,5 ,0.1 ,0.05 ,0 ,0 ,0 ,0);} // hamburger
	if(listitem == 15){SetPlayerAttachedObject(playerid,1 ,2712 ,5 ,0.1 ,-0.05 ,-0.2 ,0 ,-50 ,10);} // mop
	if(listitem == 16){SetPlayerAttachedObject(playerid,1 ,1371 , 15, 0, 0, -0.1);} // hippo
	if(listitem == 17){SetPlayerAttachedObject(playerid,1 ,953 ,15 ,0 ,-0.1 ,0.2 ,0 ,0 ,0);} // clam
	if(listitem == 18){MostrarDialogoAcessorios4(playerid);return 1;}
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Espero que goste do novo acessório!");
	return 1;
}

if(dialogid == 986) //HOLDING OBJECTS 4
{
	if(!response){MostrarDialogoAcessorios2(playerid);return 1;}
	if(!IsPlayerSpawned(playerid)){return 1;}
	if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
	if(Arena2[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
	if(IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você deve sair de seu veículo.");}
	if(listitem == 0){SetPlayerAttachedObject(playerid,1, 1243, 1, -0.2, 0.1, 0.0, 0.0, 87.0, 90.0);}
	if(listitem == 1){SetPlayerAttachedObject(playerid,1, 1235, 1, -0.2, 0.1, 0.0, 0.0, 87.0, 90.0);}
	if(listitem == 2){SetPlayerAttachedObject(playerid,1, 1223, 1, -0.2, 0.1, 0.0, 0.0, 87.0, 90.0);}
	if(listitem == 3){SetPlayerAttachedObject(playerid,1, 1215, 1, -0.2, 0.1, 0.0, 0.0, 87.0, 90.0);}
	if(listitem == 4){SetPlayerAttachedObject(playerid,1, 1209 , 1, -0.2, 0.1, 0.0, 0.0, 87.0, 90.0);}
	if(listitem == 5){SetPlayerAttachedObject(playerid,1, 1301 , 1, -0.2, 0.1, 0.0, 0.0, 87.0, 90.0);}
	if(listitem == 6){SetPlayerAttachedObject(playerid,1, 1305 , 1, -0.2, 0.1, 0.0, 0.0, 87.0, 90.0);}
	if(listitem == 7){SetPlayerAttachedObject(playerid,1, 1316 , 1, -0.2, 0.1, 0.0, 0.0, 87.0, 90.0);}
	if(listitem == 8){SetPlayerAttachedObject(playerid,1, 1346 , 1, -0.2, 0.1, 0.0, 0.0, 87.0, 90.0);}
	if(listitem == 9){SetPlayerAttachedObject(playerid,1, 1358 , 1, -0.2, 0.1, 0.0, 0.0, 87.0, 90.0);}
 	if(listitem == 10){SetPlayerAttachedObject(playerid,1, 3472 , 1, -0.2, 0.1, 0.0, 0.0, 87.0, 90.0);}
 	if(listitem == 11){SetPlayerAttachedObject(playerid,1, 3471 , 1, -0.2, 0.1, 0.0, 0.0, 87.0, 90.0);}
 	if(listitem == 12){SetPlayerAttachedObject(playerid, 1, 19065, 2, 0.120000, 0.040000, -0.003500, 0, 100, 100, 1.4, 1.4, 1.4);} //Gorro do Papai Noel
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Espero que goste do novo acessório!");
	return 1;
}

if(dialogid == 998) //Pintura Personalizada
{
	if(!response){return 1;}
	if(veiculo[playerid] == 0){SendClientMessage(playerid, COLOUR_ERRO, "ERRO: Você não tem veículo próprio, escolha um: /CS"); return 1;}
	new tmp[128], tmp2[128], Index;
	tmp = strtok(inputtext,Index), tmp2 = strtok(inputtext,Index);
	if(!IsNumeric(tmp)) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Digite somente valores numéricos de 0/1000");
	if(!IsNumeric(tmp2)) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Digite somente valores numéricos de 0/1000");
	if(strval(tmp) > 1000) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Digite somente valores numéricos de 0/1000");
	if(strval(tmp2) > 1000) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Digite somente valores numéricos de 0/1000");
	if(strlen(inputtext)==0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não digitou nada");
	ChangeVehicleColor(veiculo[playerid], strval(tmp), strval(tmp2));
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Pintura personalizada aplicada!");
	return 1;
}

if(dialogid == 999) //Clima Tempo
{
	if(!response){return 1;}
	if(XuxaPC[playerid] == 1){SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você precisa desabilitar o modo SEM LAG: /SL"); return 1;}
	if(listitem == 0){Weather[playerid] = dini_Int("ZNS.ini","clima");}
	if(listitem == 1){Weather[playerid] = 10;}
	if(listitem == 2){Weather[playerid] = 1;}
	if(listitem == 3){Weather[playerid] = 20;}
	if(listitem == 4){Weather[playerid] = 8;}
	if(listitem == 5){Weather[playerid] = 9;}
	if(listitem == 6){Weather[playerid] = 19;}
	if(listitem == 7){Weather[playerid] = 17;}
	if(listitem == 8){Weather[playerid] = 6;}
	if(listitem == 9){Weather[playerid] = 14;}
	SetPlayerWeather(playerid, Weather[playerid]);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Seu clima foi alterado com sucesso!");
	return 1;
}




    new Float: X, Float: Y, Float: Z;
    GetPlayerPos(playerid,X,Y,Z);
	if(dialogid == 2)
	{
		if(response)
		{
			if(listitem == 0)
			{
			    new allvehicles[] = "1\tAndromada\n2\tAT-400\n3\tBeagle\n4\tCropduster\n5\tDodo\n6\tHydra\n7\tNevada\n8\tRustler\n9\tShamal\n10\tSkimmer\n11\tStunt Plane";
	    		ShowPlayerDialog(playerid,3,DIALOG_STYLE_LIST,"Avioes:",allvehicles,"Selecionar","Voltar");
	    	}
	    	else if(listitem == 1)
			{
			    new allvehicles[] = "1\tCargobob\n2\tHunter\n3\tLeviathan\n4\tMaverick\n5\tNews Maverick\n6\tPolice Maverick\n7\tRaindance\n8\tSeasparrow\n9\tSparrow";
	    		ShowPlayerDialog(playerid,4,DIALOG_STYLE_LIST,"Helicopteros:",allvehicles,"Selecionar","Voltar");
			}
			else if(listitem == 2)
			{
			    new allvehicles[] = "1\tBF-400\n2\tBike\n3\tBMX\n4\tFaggio\n5\tFCR-900\n6\tFreeway\n7\tMountain Bike\n8\tNRG-500\n9\tPCJ-600\n10\tPizzaBoy\n11\tQuad\n12\tSanchez\n13\tWayfarer";
	    		ShowPlayerDialog(playerid,5,DIALOG_STYLE_LIST,"Motos:",allvehicles,"Selecionar","Voltar");
			}
			else if(listitem == 3)
			{
			    new allvehicles[] = "1\tComet\n2\tFeltzer\n3\tStallion\n4\tWindsor";
	    		ShowPlayerDialog(playerid,6,DIALOG_STYLE_LIST,"Conversiveis:",allvehicles,"Selecionar","Voltar");
			}
			else if(listitem == 4)
			{
			    new allvehicles[] = "1\tBenson\n2\tBobcat\n3\tBurrito\n4\tBoxville\n5\tBoxburg\n6\tCement Truck\n7\tDFT-300\n8\tFlatbed\n9\tLinerunner\n10\tMule\n11\tNews Van\n12\tPacker\n13\tPetrol Tanker\n14\tPicador\n15\tPony\n16\tRoad Train\n17\tRumpo\n18\tSadler\n19\tSadler Shit( Ghost Car )\n20\tTopfun\n21\tTractor\n22\tTrashmaster\n23\tUitlity Van\n24\tWalton\n25\tYankee\n26\tYosemite";
	    		ShowPlayerDialog(playerid,7,DIALOG_STYLE_LIST,"Industriais:",allvehicles,"Selecionar","Voltar");
			}
			else if(listitem == 5)
			{
			    new allvehicles[] = "1\tBlade\n2\tBroadway\n3\tRemington\n4\tSavanna\n5\tSlamvan\n6\tTahoma\n7\tTornado\n8\tVoodoo";
	    		ShowPlayerDialog(playerid,8,DIALOG_STYLE_LIST,"Lowriders:",allvehicles,"Selecionar","Voltar");
			}
			else if(listitem == 6)
			{
			    new allvehicles[] = "1\tBandito\n2\tBF Injection\n3\tDune\n4\tHuntley\n5\tLandstalker\n6\tMesa\n7\tMonster Truck\n8\tMonster Truck 'A'\n9\tMonster Truck 'B'\n10\tPatriot\n11\tRancher 'A'\n12\tRancher 'B'\n13\tSandking";
	    		ShowPlayerDialog(playerid,9,DIALOG_STYLE_LIST,"Off Road:",allvehicles,"Selecionar","Voltar");
			}
			else if(listitem == 7)
			{
			    new allvehicles[] = "1\tAmbulance\n2\tBarracks\n3\tBus\n4\tCabbie\n5\tCoach\n6\tHPV-1000 ( Cop Bike )\n7\tEnforcer\n8\tF.B.I Rancher\n9\tF.B.I Truck\n10\tFiretruck\n11\tFireTruck LA\n12\tPolice Car ( LSPD )\n13\tPolice Car ( LVPD )\n14\tPolice Car ( SFPD )\n15\tRanger\n16\tS.W.A.T\n17\tTaxi\n18\tRhino";
	    		ShowPlayerDialog(playerid,10,DIALOG_STYLE_LIST,"Serviço Publico:",allvehicles,"Selecionar","Voltar");
			}
			else if(listitem == 8)
			{
			    new allvehicles[] = "1\tAdmiral\n2\tBloodring Banger\n3\tBravura\n4\tBuccaneer\n5\tCadrona\n6\tClover\n7\tElegant\n8\tElegy\n9\tEmperor\n10\tEsperanto\n11\tFortune\n12\tGlendale Shit ( Ghost Car )\n13\tGlendale\n14\tGreenwood\n15\tHermes\n16\tIntruder\n17\tMajestic\n18\tMananal\n19\tMerit\n20\tNebula\n21\tOceanic\n22\tPremier\n23\tPrevion\n24\tPrimo\n25\tSentinel\n26\tStafford\n27\tSultan \n28\tSunrise\n29\tTampa\n30\tVicent\n31\tVirgo\n32\tWillard\n33\tWashington";
	    		ShowPlayerDialog(playerid,11,DIALOG_STYLE_LIST,"Saloons:",allvehicles,"Selecionar","Voltar");
			}
			else if(listitem == 9)
			{
			    new allvehicles[] = "1\tAlpha\n2\tBanshee\n3\tBlista Compact\n4\tBuffalo\n5\tBullet\n6\tCheetah\n7\tClub\n8\tEuros\n9\tFlash\n10\tHotring Racer 'A'\n11\tHotring Racer 'B'\n12\tHotring Racer 'C'\n13\tInfernus\n14\tJester\n15\tPhoenix\n16\tSabre\n17\tSuper GT\n18\tTurismo\n19\tUranus\n20\tZR-350";
	    		ShowPlayerDialog(playerid,12,DIALOG_STYLE_LIST,"Esportivos:",allvehicles,"Selecionar","Voltar");
			}
			else if(listitem == 10)
			{
			    new allvehicles[] = "1\tMoonbeam\n2\tPerenniel\n3\tRegina\n4\tSolair\n5\tStratum";
	    		ShowPlayerDialog(playerid,13,DIALOG_STYLE_LIST,"Peruas:",allvehicles,"Selecionar","Voltar");
			}
			else if(listitem == 11)
			{
			    new allvehicles[] = "1\tCoastguard\n2\tDinghy\n3\tJetmax\n4\tLaunch\n5\tMarquis\n6\tPredator\n7\tReefer\n8\tSpeeder\n9\tSquallo\n10\tTropic";
	    		ShowPlayerDialog(playerid,14,DIALOG_STYLE_LIST,"Barcos:",allvehicles,"Selecionar","Voltar");
			}
			else if(listitem == 12)
			{
			    new allvehicles[] = "1\tBaggage\n2\tCaddy\n3\tCamper 'A'\n4\tCamper 'B'\n5\tCobine Harvester\n6\tDozer\n7\tDumper\n8\tForklift\n9\tHotknife\n10\tHustler\n11\tHotdog\n12\tKart\n13\tMower\n14\tMr. Whoopee\n15\tRomero\n16\tSecuricar\n17\tStretch\n18\tSweeper\n19\tTowtruck\n20\tTug\n21\tVortex";
	    		ShowPlayerDialog(playerid,15,DIALOG_STYLE_LIST,"Veiculos Unicos:",allvehicles,"Selecionar","Voltar");
			}
			else if(listitem == 13)
			{
			    new allvehicles[] = "1\tRC Bandit\n2\tRC Baron\n3\tRC Raider'\n4\tRC Goblin'\n5\tRC Tiger\n6\tRC Cam";
	    		ShowPlayerDialog(playerid,16,DIALOG_STYLE_LIST,"Veiculos RC:",allvehicles,"Selecionar","Voltar");
			}
			else if(listitem == 14)
			{
			    new allvehicles[] = "1\tArticle Trailer\n2\tArticle Trailer 2\n3\tArticle Trailer 3'\n4\tBaggage Trailer 'A''\n5\tBaggage Trailer 'B'\n6\tFarm Trailer\n7\tFreight Frat Trailer(Train)\n8\tFreight Box Trailer(Train)\n9\tPetrol Trailer\n10\tStreak Trailer(Train)\n11\tStairs Trailer\n12\tUitlity Trailer";
	    		ShowPlayerDialog(playerid,17,DIALOG_STYLE_LIST,"Trailers Vehicles:",allvehicles,"Selecionar","Voltar");
			}
		}
	}
 else if(dialogid == 3)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    CriarVeiculoParaPlayer(playerid, 592);
			}
			else if(listitem == 1)
			{
			    CriarVeiculoParaPlayer(playerid, 577);
			}
			else if(listitem == 2)
			{
			    CriarVeiculoParaPlayer(playerid, 511);
			}
			else if(listitem == 3)
			{
			    CriarVeiculoParaPlayer(playerid, 512);
			}
			else if(listitem == 4)
			{
			    CriarVeiculoParaPlayer(playerid, 593);
			}
			else if(listitem == 5)
			{
			    CriarVeiculoParaPlayer(playerid, 520);
			}
			else if(listitem == 6)
			{
			    CriarVeiculoParaPlayer(playerid, 553);
			}
			else if(listitem == 7)
			{
			    CriarVeiculoParaPlayer(playerid, 476);
			}
			else if(listitem == 8)
			{
			    CriarVeiculoParaPlayer(playerid, 519);
			}
			else if(listitem == 9)
			{
			    CriarVeiculoParaPlayer(playerid, 460);
			}
			else if(listitem == 10)
			{
			    CriarVeiculoParaPlayer(playerid, 513);
			}
		}
		else
		{
new allvehicles[] = "1\tAvioes\n2\tHelicopteros\n3\tMotos\n4\tConvesiveis\n5\tIndustriais\n6\tLowriders\n7\tOffRoad\n8\tServiços Publicos\n9\tSaloons\n10\tEsportivos\n11\tPeruas\n12\tBarcos\n13\tVeiculos Unicos\n14\tVeiculos RC\n15\tTrailers";
ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST,"Lista de Veiculos:",allvehicles,"Selecionar","Voltar");
		}
	}
	else if(dialogid == 4)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    CriarVeiculoParaPlayer(playerid, 548);
			}
			else if(listitem == 1)
			{
			    CriarVeiculoParaPlayer(playerid, 425);
			}
			else if(listitem == 2)
			{
			    CriarVeiculoParaPlayer(playerid, 417);
			}
			else if(listitem == 3)
			{
			    CriarVeiculoParaPlayer(playerid, 487);
			}
			else if(listitem == 4)
			{
			    CriarVeiculoParaPlayer(playerid, 488);
			}
			else if(listitem == 5)
			{
			    CriarVeiculoParaPlayer(playerid, 497);
			}
			else if(listitem == 6)
			{
			    CriarVeiculoParaPlayer(playerid, 563);
			}
			else if(listitem == 7)
			{
			    CriarVeiculoParaPlayer(playerid, 447);
			}
			else if(listitem == 8)
			{
			    CriarVeiculoParaPlayer(playerid, 469);
			}
		}
		else
		{
new allvehicles[] = "1\tAvioes\n2\tHelicopteros\n3\tMotos\n4\tConvesiveis\n5\tIndustriais\n6\tLowriders\n7\tOffRoad\n8\tServiços Publicos\n9\tSaloons\n10\tEsportivos\n11\tPeruas\n12\tBarcos\n13\tVeiculos Unicos\n14\tVeiculos RC\n15\tTrailers";
ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST,"Lista de Veiculos:",allvehicles,"Selecionar","Voltar");
		}
	}
	else if(dialogid == 5)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    CriarVeiculoParaPlayer(playerid, 581);
			}
			else if(listitem == 1)
			{
			    CriarVeiculoParaPlayer(playerid, 509);
			}
			else if(listitem == 2)
			{
			    CriarVeiculoParaPlayer(playerid, 481);
			}
			else if(listitem == 3)
			{
			    CriarVeiculoParaPlayer(playerid, 462);
			}
			else if(listitem == 4)
			{
			    CriarVeiculoParaPlayer(playerid, 521);
			}
			else if(listitem == 5)
			{
			    CriarVeiculoParaPlayer(playerid, 463);
			}
			else if(listitem == 6)
			{
			    CriarVeiculoParaPlayer(playerid, 510);
			}
			else if(listitem == 7)
			{
			    CriarVeiculoParaPlayer(playerid, 522);
			}
			else if(listitem == 8)
			{
			    CriarVeiculoParaPlayer(playerid, 461);
			}
			else if(listitem == 9)
			{
			    CriarVeiculoParaPlayer(playerid, 448);
			}
			else if(listitem == 10)
			{
			    CriarVeiculoParaPlayer(playerid, 471);
			}
			else if(listitem == 11)
			{
			    CriarVeiculoParaPlayer(playerid, 468);
			}
			else if(listitem == 12)
			{
			    CriarVeiculoParaPlayer(playerid, 586);
			}
		}
		else
		{
new allvehicles[] = "1\tAvioes\n2\tHelicopteros\n3\tMotos\n4\tConvesiveis\n5\tIndustriais\n6\tLowriders\n7\tOffRoad\n8\tServiços Publicos\n9\tSaloons\n10\tEsportivos\n11\tPeruas\n12\tBarcos\n13\tVeiculos Unicos\n14\tVeiculos RC\n15\tTrailers";
ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST,"Lista de Veiculos:",allvehicles,"Selecionar","Voltar");
		}
	}
	else if(dialogid == 6)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    CriarVeiculoParaPlayer(playerid, 480);
			}
			else if(listitem == 1)
			{
			    CriarVeiculoParaPlayer(playerid, 533);
			}
			else if(listitem == 2)
			{
			    CriarVeiculoParaPlayer(playerid, 439);
			}
			else if(listitem == 3)
			{
			    CriarVeiculoParaPlayer(playerid, 555);
			}
		}
		else
		{
new allvehicles[] = "1\tAvioes\n2\tHelicopteros\n3\tMotos\n4\tConvesiveis\n5\tIndustriais\n6\tLowriders\n7\tOffRoad\n8\tServiços Publicos\n9\tSaloons\n10\tEsportivos\n11\tPeruas\n12\tBarcos\n13\tVeiculos Unicos\n14\tVeiculos RC\n15\tTrailers";
ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST,"Lista de Veiculos:",allvehicles,"Selecionar","Voltar");
		}
	}
	else if(dialogid == 7)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    CriarVeiculoParaPlayer(playerid, 499);
			}
			else if(listitem == 1)
			{
			    CriarVeiculoParaPlayer(playerid, 422);
			}
			else if(listitem == 2)
			{
			    CriarVeiculoParaPlayer(playerid, 482);
			}
			else if(listitem == 3)
			{
			    CriarVeiculoParaPlayer(playerid, 498);
			}
			else if(listitem == 4)
			{
			    CriarVeiculoParaPlayer(playerid, 609);
			}
			else if(listitem == 5)
			{
			    CriarVeiculoParaPlayer(playerid, 524);
			}
			else if(listitem == 6)
			{
			    CriarVeiculoParaPlayer(playerid, 578);
			}
			else if(listitem == 7)
			{
			    CriarVeiculoParaPlayer(playerid, 455);
			}
			else if(listitem == 8)
			{
			    CriarVeiculoParaPlayer(playerid, 403);
			}
			else if(listitem == 9)
			{
			    CriarVeiculoParaPlayer(playerid, 414);
			}
			else if(listitem == 10)
			{
			    CriarVeiculoParaPlayer(playerid, 582);
			}
			else if(listitem == 11)
			{
			    CriarVeiculoParaPlayer(playerid, 443);
			}
			else if(listitem == 12)
			{
			    CriarVeiculoParaPlayer(playerid, 514);
			}
			else if(listitem == 13)
			{
			    CriarVeiculoParaPlayer(playerid, 600);
			}
			else if(listitem == 14)
			{
			    CriarVeiculoParaPlayer(playerid, 413);
			}
			else if(listitem == 15)
			{
			    CriarVeiculoParaPlayer(playerid, 515);
			}
			else if(listitem == 16)
			{
			    CriarVeiculoParaPlayer(playerid, 440);
			}
			else if(listitem == 17)
			{
			    CriarVeiculoParaPlayer(playerid, 543);
			}
			else if(listitem == 18)
			{
			    CriarVeiculoParaPlayer(playerid, 605);
			}
			else if(listitem == 19)
			{
			    CriarVeiculoParaPlayer(playerid, 459);
			}
			else if(listitem == 20)
			{
			    CriarVeiculoParaPlayer(playerid, 531);
			}
			else if(listitem == 21)
			{
			    CriarVeiculoParaPlayer(playerid, 408);
			}
			else if(listitem == 22)
			{
			    CriarVeiculoParaPlayer(playerid, 552);
			}
			else if(listitem == 23)
			{
			    CriarVeiculoParaPlayer(playerid, 478);
			}
			else if(listitem == 24)
			{
			    CriarVeiculoParaPlayer(playerid, 456);
			}
			else if(listitem == 25)
			{
			    CriarVeiculoParaPlayer(playerid, 554);
			}
		}
		else
		{
new allvehicles[] = "1\tAvioes\n2\tHelicopteros\n3\tMotos\n4\tConvesiveis\n5\tIndustriais\n6\tLowriders\n7\tOffRoad\n8\tServiços Publicos\n9\tSaloons\n10\tEsportivos\n11\tPeruas\n12\tBarcos\n13\tVeiculos Unicos\n14\tVeiculos RC\n15\tTrailers";
ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST,"Lista de Veiculos:",allvehicles,"Selecionar","Voltar");
		}
	}
	else if(dialogid == 8)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    CriarVeiculoParaPlayer(playerid, 536);
			}
			else if(listitem == 1)
			{
			    CriarVeiculoParaPlayer(playerid, 575);
			}
			else if(listitem == 2)
			{
			    CriarVeiculoParaPlayer(playerid, 534);
			}
			else if(listitem == 3)
			{
			    CriarVeiculoParaPlayer(playerid, 567);
			}
			else if(listitem == 4)
			{
			    CriarVeiculoParaPlayer(playerid, 535);
			}
			else if(listitem == 5)
			{
			    CriarVeiculoParaPlayer(playerid, 566);
			}
			else if(listitem == 6)
			{
			    CriarVeiculoParaPlayer(playerid, 576);
			}
			else if(listitem == 7)
			{
			    CriarVeiculoParaPlayer(playerid, 412);
			}
		}
		else
		{
new allvehicles[] = "1\tAvioes\n2\tHelicopteros\n3\tMotos\n4\tConvesiveis\n5\tIndustriais\n6\tLowriders\n7\tOffRoad\n8\tServiços Publicos\n9\tSaloons\n10\tEsportivos\n11\tPeruas\n12\tBarcos\n13\tVeiculos Unicos\n14\tVeiculos RC\n15\tTrailers";
ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST,"Lista de Veiculos:",allvehicles,"Selecionar","Voltar");
		}
	}
	else if(dialogid == 9)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    CriarVeiculoParaPlayer(playerid, 568);
			}
			else if(listitem == 1)
			{
			    CriarVeiculoParaPlayer(playerid, 424);
			}
			else if(listitem == 2)
			{
			    CriarVeiculoParaPlayer(playerid, 573);
			}
			else if(listitem == 3)
			{
			    CriarVeiculoParaPlayer(playerid, 579);
			}
			else if(listitem == 4)
			{
			    CriarVeiculoParaPlayer(playerid, 400);
			}
			else if(listitem == 5)
			{
			    CriarVeiculoParaPlayer(playerid, 500);
			}
			else if(listitem == 6)
			{
			    CriarVeiculoParaPlayer(playerid, 444);
			}
			else if(listitem == 7)
			{
			    CriarVeiculoParaPlayer(playerid, 556);
			}
			else if(listitem == 8)
			{
			    CriarVeiculoParaPlayer(playerid, 557);
			}
			else if(listitem == 9)
			{
			    CriarVeiculoParaPlayer(playerid, 470);
			}
			else if(listitem == 10)
			{
			    CriarVeiculoParaPlayer(playerid, 489);
			}
			else if(listitem == 11)
			{
			    CriarVeiculoParaPlayer(playerid, 505);
			}
			else if(listitem == 12)
			{
			    CriarVeiculoParaPlayer(playerid, 495);
			}
		}
		else
		{
new allvehicles[] = "1\tAvioes\n2\tHelicopteros\n3\tMotos\n4\tConvesiveis\n5\tIndustriais\n6\tLowriders\n7\tOffRoad\n8\tServiços Publicos\n9\tSaloons\n10\tEsportivos\n11\tPeruas\n12\tBarcos\n13\tVeiculos Unicos\n14\tVeiculos RC\n15\tTrailers";
ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST,"Lista de Veiculos:",allvehicles,"Selecionar","Voltar");
		}
	}
	else if(dialogid == 10)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    CriarVeiculoParaPlayer(playerid, 416);
			}
			else if(listitem == 1)
			{
			    CriarVeiculoParaPlayer(playerid, 433);
			}
			else if(listitem == 2)
			{
			    CriarVeiculoParaPlayer(playerid, 431);
			}
			else if(listitem == 3)
			{
			    CriarVeiculoParaPlayer(playerid, 438);
			}
			else if(listitem == 4)
			{
			    CriarVeiculoParaPlayer(playerid, 437);
			}
			else if(listitem == 5)
			{
			    CriarVeiculoParaPlayer(playerid, 523);
			}
			else if(listitem == 6)
			{
			    CriarVeiculoParaPlayer(playerid, 427);
			}
			else if(listitem == 7)
			{
			    CriarVeiculoParaPlayer(playerid, 490);
			}
			else if(listitem == 8)
			{
			    CriarVeiculoParaPlayer(playerid, 528);
			}
			else if(listitem == 9)
			{
			    CriarVeiculoParaPlayer(playerid, 407);
			}
			else if(listitem == 10)
			{
			    CriarVeiculoParaPlayer(playerid, 544);
			}
			else if(listitem == 11)
			{
			    CriarVeiculoParaPlayer(playerid, 596);
			}
			else if(listitem == 12)
			{
			    CriarVeiculoParaPlayer(playerid, 598);
			}
			else if(listitem == 13)
			{
			    CriarVeiculoParaPlayer(playerid, 597);
			}
			else if(listitem == 14)
			{
			    CriarVeiculoParaPlayer(playerid, 599);
			}
			else if(listitem == 15)
			{
			    CriarVeiculoParaPlayer(playerid, 601);
			}
			else if(listitem == 16)
			{
			    CriarVeiculoParaPlayer(playerid, 420);
			}
			else if(listitem == 17)
			{
			    CriarVeiculoParaPlayer(playerid, 432);
			}
		}
		else
		{
new allvehicles[] = "1\tAvioes\n2\tHelicopteros\n3\tMotos\n4\tConvesiveis\n5\tIndustriais\n6\tLowriders\n7\tOffRoad\n8\tServiços Publicos\n9\tSaloons\n10\tEsportivos\n11\tPeruas\n12\tBarcos\n13\tVeiculos Unicos\n14\tVeiculos RC\n15\tTrailers";
ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST,"Lista de Veiculos:",allvehicles,"Selecionar","Voltar");
		}
	}
	else if(dialogid == 11)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    CriarVeiculoParaPlayer(playerid, 445);
			}
			else if(listitem == 1)
			{
			    CriarVeiculoParaPlayer(playerid, 504);
			}
			else if(listitem == 2)
			{
			    CriarVeiculoParaPlayer(playerid, 401);
			}
			else if(listitem == 3)
			{
			    CriarVeiculoParaPlayer(playerid, 518);
			}
			else if(listitem == 4)
			{
			    CriarVeiculoParaPlayer(playerid, 527);
			}
			else if(listitem == 5)
			{
			    CriarVeiculoParaPlayer(playerid, 542);
			}
			else if(listitem == 6)
			{
			    CriarVeiculoParaPlayer(playerid, 507);
			}
			else if(listitem == 7)
			{
			    CriarVeiculoParaPlayer(playerid, 562);
			}
			else if(listitem == 8)
			{
			    CriarVeiculoParaPlayer(playerid, 585);
			}
			else if(listitem == 9)
			{
			    CriarVeiculoParaPlayer(playerid, 419);
			}
			else if(listitem == 10)
			{
			    CriarVeiculoParaPlayer(playerid, 526);
			}
			else if(listitem == 11)
			{
			    CriarVeiculoParaPlayer(playerid, 604);
			}
			else if(listitem == 12)
			{
			    CriarVeiculoParaPlayer(playerid, 466);
			}
			else if(listitem == 13)
			{
			    CriarVeiculoParaPlayer(playerid, 492);
			}
			else if(listitem == 14)
			{
			    CriarVeiculoParaPlayer(playerid, 474);
			}
			else if(listitem == 15)
			{
			    CriarVeiculoParaPlayer(playerid, 546);
			}
			else if(listitem == 16)
			{
			    CriarVeiculoParaPlayer(playerid, 517);
			}
			else if(listitem == 17)
			{
			    CriarVeiculoParaPlayer(playerid, 310);
			}
			else if(listitem == 18)
			{
			    CriarVeiculoParaPlayer(playerid, 551);
			}
			else if(listitem == 19)
			{
			    CriarVeiculoParaPlayer(playerid, 516);
			}
			else if(listitem == 20)
			{
			    CriarVeiculoParaPlayer(playerid, 467);
			}
			else if(listitem == 21)
			{
			    CriarVeiculoParaPlayer(playerid, 426);
			}
			else if(listitem == 22)
			{
			    CriarVeiculoParaPlayer(playerid, 436);
			}
			else if(listitem == 23)
			{
			    CriarVeiculoParaPlayer(playerid, 547);
			}
			else if(listitem == 24)
			{
			    CriarVeiculoParaPlayer(playerid, 405);
			}
			else if(listitem == 25)
			{
			    CriarVeiculoParaPlayer(playerid, 580);
			}
			else if(listitem == 26)
			{
			    CriarVeiculoParaPlayer(playerid, 560);
			}
			else if(listitem == 27)
			{
			    CriarVeiculoParaPlayer(playerid, 550);
			}
			else if(listitem == 28)
			{
			    CriarVeiculoParaPlayer(playerid, 549);
			}
			else if(listitem == 29)
			{
			    CriarVeiculoParaPlayer(playerid, 540);
			}
			else if(listitem == 30)
			{
			    CriarVeiculoParaPlayer(playerid, 491);
			}
			else if(listitem == 31)
			{
			    CriarVeiculoParaPlayer(playerid, 529);
			}
			else if(listitem == 32)
			{
			    CriarVeiculoParaPlayer(playerid, 421);
			}
		}
		else
		{
new allvehicles[] = "1\tAvioes\n2\tHelicopteros\n3\tMotos\n4\tConvesiveis\n5\tIndustriais\n6\tLowriders\n7\tOffRoad\n8\tServiços Publicos\n9\tSaloons\n10\tEsportivos\n11\tPeruas\n12\tBarcos\n13\tVeiculos Unicos\n14\tVeiculos RC\n15\tTrailers";
ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST,"Lista de Veiculos:",allvehicles,"Selecionar","Voltar");
		}
	}
	else if(dialogid == 12)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    CriarVeiculoParaPlayer(playerid, 602);
			}
			else if(listitem == 1)
			{
			    CriarVeiculoParaPlayer(playerid, 429);
			}
			else if(listitem == 2)
			{
			    CriarVeiculoParaPlayer(playerid, 496);
			}
			else if(listitem == 3)
			{
			    CriarVeiculoParaPlayer(playerid, 402);
			}
			else if(listitem == 4)
			{
			    CriarVeiculoParaPlayer(playerid, 541);
			}
			else if(listitem == 5)
			{
			    CriarVeiculoParaPlayer(playerid, 415);
			}
			else if(listitem == 6)
			{
			    CriarVeiculoParaPlayer(playerid, 589);
			}
			else if(listitem == 7)
			{
			    CriarVeiculoParaPlayer(playerid, 587);
			}
			else if(listitem == 8)
			{
			    CriarVeiculoParaPlayer(playerid, 565);
			}
			else if(listitem == 9)
			{
			    CriarVeiculoParaPlayer(playerid, 494);
			}
			else if(listitem == 10)
			{
			    CriarVeiculoParaPlayer(playerid, 502);
			}
			else if(listitem == 11)
			{
			    CriarVeiculoParaPlayer(playerid, 503);
			}
			else if(listitem == 12)
			{
			    CriarVeiculoParaPlayer(playerid, 411);
			}
			else if(listitem == 13)
			{
			    CriarVeiculoParaPlayer(playerid, 559);
			}
			else if(listitem == 14)
			{
			    CriarVeiculoParaPlayer(playerid, 603);
			}
			else if(listitem == 15)
			{
			    CriarVeiculoParaPlayer(playerid, 475);
			}
			else if(listitem == 16)
			{
			    CriarVeiculoParaPlayer(playerid, 506);
			}
			else if(listitem == 17)
			{
			    CriarVeiculoParaPlayer(playerid, 451);
			}
			else if(listitem == 18)
			{
			    CriarVeiculoParaPlayer(playerid, 558);
			}
			else if(listitem == 19)
			{
			    CriarVeiculoParaPlayer(playerid, 477);
			}
		}
		else
		{
new allvehicles[] = "1\tAvioes\n2\tHelicopteros\n3\tMotos\n4\tConvesiveis\n5\tIndustriais\n6\tLowriders\n7\tOffRoad\n8\tServiços Publicos\n9\tSaloons\n10\tEsportivos\n11\tPeruas\n12\tBarcos\n13\tVeiculos Unicos\n14\tVeiculos RC\n15\tTrailers";
ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST,"Lista de Veiculos:",allvehicles,"Selecionar","Voltar");
		}
	}
	else if(dialogid == 13)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    CriarVeiculoParaPlayer(playerid, 418);
			}
			else if(listitem == 1)
			{
			    CriarVeiculoParaPlayer(playerid, 404);
			}
			else if(listitem == 2)
			{
			    CriarVeiculoParaPlayer(playerid, 479);
			}
			else if(listitem == 3)
			{
			    CriarVeiculoParaPlayer(playerid, 458);
			}
			else if(listitem == 4)
			{
			    CriarVeiculoParaPlayer(playerid, 561);
			}
		}
		else
		{
new allvehicles[] = "1\tAvioes\n2\tHelicopteros\n3\tMotos\n4\tConvesiveis\n5\tIndustriais\n6\tLowriders\n7\tOffRoad\n8\tServiços Publicos\n9\tSaloons\n10\tEsportivos\n11\tPeruas\n12\tBarcos\n13\tVeiculos Unicos\n14\tVeiculos RC\n15\tTrailers";
ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST,"Lista de Veiculos:",allvehicles,"Selecionar","Voltar");
		}
	}
	else if(dialogid == 14)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    CriarVeiculoParaPlayer(playerid, 472);
			}
			else if(listitem == 1)
			{
			    CriarVeiculoParaPlayer(playerid, 473);
			}
			else if(listitem == 2)
			{
			    CriarVeiculoParaPlayer(playerid, 493);
			}
			else if(listitem == 3)
			{
			    CriarVeiculoParaPlayer(playerid, 595);
			}
			else if(listitem == 4)
			{
			    CriarVeiculoParaPlayer(playerid, 484);
			}
			else if(listitem == 5)
			{
			    CriarVeiculoParaPlayer(playerid, 430);
			}
			else if(listitem == 6)
			{
			    CriarVeiculoParaPlayer(playerid, 453);
			}
			else if(listitem == 7)
			{
			    CriarVeiculoParaPlayer(playerid, 452);
			}
			else if(listitem == 8)
			{
			    CriarVeiculoParaPlayer(playerid, 446);
			}
			else if(listitem == 9)
			{
			    CriarVeiculoParaPlayer(playerid, 454);
			}
		}
		else
		{
new allvehicles[] = "1\tAvioes\n2\tHelicopteros\n3\tMotos\n4\tConvesiveis\n5\tIndustriais\n6\tLowriders\n7\tOffRoad\n8\tServiços Publicos\n9\tSaloons\n10\tEsportivos\n11\tPeruas\n12\tBarcos\n13\tVeiculos Unicos\n14\tVeiculos RC\n15\tTrailers";
ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST,"Lista de Veiculos:",allvehicles,"Selecionar","Voltar");
		}
	}
	else if(dialogid == 15)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    CriarVeiculoParaPlayer(playerid, 485);
			}
			else if(listitem == 1)
			{
			    CriarVeiculoParaPlayer(playerid, 457);
			}
			else if(listitem == 2)
			{
			    CriarVeiculoParaPlayer(playerid, 483);
			}
			else if(listitem == 3)
			{
			    CriarVeiculoParaPlayer(playerid, 508);
			}
			else if(listitem == 4)
			{
			    CriarVeiculoParaPlayer(playerid, 532);
			}
			else if(listitem == 5)
			{
			    CriarVeiculoParaPlayer(playerid, 486);
			}
			else if(listitem == 6)
			{
			    CriarVeiculoParaPlayer(playerid, 406);
			}
			else if(listitem == 7)
			{
			    CriarVeiculoParaPlayer(playerid, 530);
			}
			else if(listitem == 8)
			{
			    CriarVeiculoParaPlayer(playerid, 434);
			}
			else if(listitem == 9)
			{
			    CriarVeiculoParaPlayer(playerid, 545);
			}
			else if(listitem == 10)
			{
			    CriarVeiculoParaPlayer(playerid, 588);
			}
			else if(listitem == 11)
			{
			    CriarVeiculoParaPlayer(playerid, 571);
			}
			else if(listitem == 12)
			{
			    CriarVeiculoParaPlayer(playerid, 572);
			}
			else if(listitem == 13)
			{
			    CriarVeiculoParaPlayer(playerid, 423);
			}
			else if(listitem == 14)
			{
			    CriarVeiculoParaPlayer(playerid, 442);
			}
			else if(listitem == 15)
			{
			    CriarVeiculoParaPlayer(playerid, 428);
			}
			else if(listitem == 16)
			{
			    CriarVeiculoParaPlayer(playerid, 409);
			}
			else if(listitem == 17)
			{
			    CriarVeiculoParaPlayer(playerid, 574);
			}
			else if(listitem == 18)
			{
			    CriarVeiculoParaPlayer(playerid, 525);
			}
			else if(listitem == 19)
			{
			    CriarVeiculoParaPlayer(playerid, 583);
			}
			else if(listitem == 20)
			{
			    CriarVeiculoParaPlayer(playerid, 539);
			}
		}
		else
		{
new allvehicles[] = "1\tAvioes\n2\tHelicopteros\n3\tMotos\n4\tConvesiveis\n5\tIndustriais\n6\tLowriders\n7\tOffRoad\n8\tServiços Publicos\n9\tSaloons\n10\tEsportivos\n11\tPeruas\n12\tBarcos\n13\tVeiculos Unicos\n14\tVeiculos RC\n15\tTrailers";
ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST,"Lista de Veiculos:",allvehicles,"Selecionar","Voltar");
		}
	}
	else if(dialogid == 16)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    CriarVeiculoParaPlayer(playerid, 441);
			}
			else if(listitem == 1)
			{
			    CriarVeiculoParaPlayer(playerid, 464);
			}
			else if(listitem == 2)
			{
			    CriarVeiculoParaPlayer(playerid, 465);
			}
			else if(listitem == 3)
			{
			    CriarVeiculoParaPlayer(playerid, 501);
			}
			else if(listitem == 4)
			{
			    CriarVeiculoParaPlayer(playerid, 564);
			}
			else if(listitem == 5)
			{
			    CriarVeiculoParaPlayer(playerid, 594);
			}
		}
		else
		{
new allvehicles[] = "1\tAvioes\n2\tHelicopteros\n3\tMotos\n4\tConvesiveis\n5\tIndustriais\n6\tLowriders\n7\tOffRoad\n8\tServiços Publicos\n9\tSaloons\n10\tEsportivos\n11\tPeruas\n12\tBarcos\n13\tVeiculos Unicos\n14\tVeiculos RC\n15\tTrailers";
ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST,"Lista de Veiculos:",allvehicles,"Selecionar","Voltar");
		}
	}
	else if(dialogid == 17)
	{
	    if(response)
		{
			if(listitem == 0)
			{
			    CriarVeiculoParaPlayer(playerid, 435);
			}
			else if(listitem == 1)
			{
			    CriarVeiculoParaPlayer(playerid, 450);
			}
			else if(listitem == 2)
			{
			    CriarVeiculoParaPlayer(playerid, 591);
			}
			else if(listitem == 3)
			{
			    CriarVeiculoParaPlayer(playerid, 606);
			}
			else if(listitem == 4)
			{
			    CriarVeiculoParaPlayer(playerid, 607);
			}
			else if(listitem == 5)
			{
			    CriarVeiculoParaPlayer(playerid, 610);
			}
			else if(listitem == 6)
			{
			    CriarVeiculoParaPlayer(playerid, 569);
			}
			else if(listitem == 7)
			{
			    CriarVeiculoParaPlayer(playerid, 590);
			}
			else if(listitem == 8)
			{
			    CriarVeiculoParaPlayer(playerid,584);
			}
			else if(listitem == 9)
			{
			    CriarVeiculoParaPlayer(playerid, 570);
			}
			else if(listitem == 10)
			{
			    CriarVeiculoParaPlayer(playerid, 608);
			}
			else if(listitem == 11)
			{
			    CriarVeiculoParaPlayer(playerid, 611);
			}
		}
		else
		{
			new allvehicles[] = "1\tAvioes\n2\tHelicopteros\n3\tMotos\n4\tConvesiveis\n5\tIndustriais\n6\tLowriders\n7\tOffRoad\n8\tServiços Publicos\n9\tSaloons\n10\tEsportivos\n11\tPeruas\n12\tBarcos\n13\tVeiculos Unicos\n14\tVeiculos RC\n15\tTrailers";
			ShowPlayerDialog(playerid,2,DIALOG_STYLE_LIST,"Lista de Veiculos:",allvehicles,"Selecionar","Voltar");
		}
	}
	return 1;
}

forward InfiniteNitro();
public InfiniteNitro()
{
    new vehicleid;
 for(new i; i < GetMaxPlayers(); i++)
	{
	        if(GetPlayerState(i)== PLAYER_STATE_DRIVER)
	        {
	            vehicleid=GetPlayerVehicleID(i);
	    		if(CheckVehicle(vehicleid))
				AddVehicleComponent(vehicleid,1010);
			}

	}
	return 1;
}

stock CheckVehicle(vehicleid)
{
    #define MAX_INVALID_NOS_VEHICLES 33

    new InvalidNOSVehicles[MAX_INVALID_NOS_VEHICLES] =
    {
 		441,581,523,462,521,463,522,461,448,468,586,509,481,510,472,473,493,595,484,430,453,452,446,454,590,569,537,538,570,449,513,520,476
    };

	for(new i = 0; i < MAX_INVALID_NOS_VEHICLES; i++)
	{
 		if(GetVehicleModel(vehicleid) == InvalidNOSVehicles[i]) return false;
	}
    return true;
}



//VELOCIMETRO
forward Velocimetro();
public Velocimetro()
{
for(new i; i < GetMaxPlayers(); i++){
if(IsPlayerInAnyVehicle(i)){
new estr[16];
new speed = GetPlayerSpeed(i,true);
format(estr,16,"%d km/h",speed);
if(!speed || speed < 0) {TextDrawSetString(TXTVELOCIDADE[i]," 0 km/h");}
TextDrawSetString(TXTVELOCIDADE[i],estr);}}
return 1;
}

stock GetPlayerSpeed2D(playerid,bool:kmh) // by misco edit by gamer_z
{
new Float:Vx,Float:Vy,Float:Vz,Float:rtn;
if(IsPlayerInAnyVehicle(playerid)) GetVehicleVelocity(GetPlayerVehicleID(playerid),Vx,Vy,Vz); else GetPlayerVelocity(playerid,Vx,Vy,Vz);
rtn = floatsqroot(Vx*Vx + Vy*Vy);
return kmh?floatround(rtn * 100 * 1.63):floatround(rtn * 100);
}

//VELOCIMETRO
stock GetPlayerSpeed(playerid,bool:kmh) // by misco edit by gamer_z
{
new Float:Vx,Float:Vy,Float:Vz,Float:rtn;
if(IsPlayerInAnyVehicle(playerid)) GetVehicleVelocity(GetPlayerVehicleID(playerid),Vx,Vy,Vz); else GetPlayerVelocity(playerid,Vx,Vy,Vz);
rtn = floatsqroot(Vx*Vx + Vy*Vy + Vz*Vz);
return kmh?floatround(rtn * 100 * 1.63):floatround(rtn * 100);
}

forward Weaponcheck();
public Weaponcheck()
{
 for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i))
    {
		if(IsPlayerSpawned(i)){

		//IGNORAR ADMINS
		if(CallRemoteFunction("GetPlayerAdminLevel","i",i) < 1){

		//BANIR QUEM ESTIVER COM CAMERA GOGGLES E RPG
		if(GetPlayerWeapon(i) == 43||GetPlayerWeapon(i) == 44||GetPlayerWeapon(i) == 45||GetPlayerWeapon(i) == 36||GetPlayerWeapon(i) == 37 || GetPlayerWeapon(i) == 18)
		{
		if(IsPlayerSpawned(i)){
		WeaponHackBan(i);}
        continue;
		}

		//BANIR SE ESTIVER FORA DA ARENA DE MINIGUN
		if(GetPlayerWeapon(i) == 38)
        {
        if(ArenaTipo[i] != 4 && ArenaTipo[i] != 69)
        {
        if(IsPlayerSpawned(i)){
		WeaponHackBan(i);}
        continue;
		}
		}

		//BANIR SE ESTIVER FORA DA ARENA DE BAZUCA
		if(GetPlayerWeapon(i) == 35)
        {
        if(ArenaTipo[i] != 5 && ArenaTipo[i] != 69)
        {
        if(IsPlayerSpawned(i)){
		WeaponHackBan(i);}
		continue;
		}
		}
		}
		}
		}
	}
	return 1;
}



public OnPlayerKeyStateChange(playerid, newkeys, oldkeys){

    if(IsPlayerInAnyVehicle(playerid))	{
		new nos = GetPlayerVehicleID(playerid);
		if(Nitro(nos) && (oldkeys & 1 || oldkeys & 4)){
			RemoveVehicleComponent(nos, 1010);
			AddVehicleComponent(nos, 1010);
		}
	}
	//Speed
    if (newkeys & KEY_FIRE && StuntSuperSpeed[playerid] == true)
    {
        if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        {
            ModifyVehicleSpeed(GetPlayerVehicleID(playerid),100);
        }
	}

	//Jump
 	if (newkeys & KEY_ACTION && StuntSuperSpeed[playerid] == true)
    {
        if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        {
       		new Float:Vx,Float:Vy,Float:Vz;
			GetVehicleVelocity(GetPlayerVehicleID(playerid),Vx,Vy,Vz);
			SetVehicleVelocity(GetPlayerVehicleID(playerid),Vx,Vy,Vz+0.20);
        }
	}

//REBOCAR TOWTRUCK & TRACTOR
if ((newkeys==KEY_ACTION)&&(IsPlayerInAnyVehicle(playerid))&&(GetPlayerState(playerid)==PLAYER_STATE_DRIVER)){
if (GetVehicleModel(GetPlayerVehicleID(playerid)) == 525 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 531){
new Float:pX,Float:pY,Float:pZ;GetPlayerPos(playerid,pX,pY,pZ);
new Float:vX,Float:vY,Float:vZ;new Found=0;new vid=0;
while((vid<MAX_VEHICLES)&&(!Found)){vid++;GetVehiclePos(vid,vX,vY,vZ);
if ((floatabs(pX-vX)<7.0)&&(floatabs(pY-vY)<7.0)&&(floatabs(pZ-vZ)<7.0)&&(vid!=GetPlayerVehicleID(playerid))){Found=1;
if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))){
DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));}
AttachTrailerToVehicle(vid,GetPlayerVehicleID(playerid));}}}}
return 1;}

stock WeaponHackBan(i){
CallRemoteFunction("BanirPlayerEx","is",i,"Tentou usar arma ilegal");
return 1;
}

forward GetArenaTipo(playerid);
public GetArenaTipo(playerid){
return ArenaTipo[playerid];}

forward NotificarEx(string[],tempo);
public NotificarEx(string[],tempo)
{
if(tempo < 0){TextDrawSetString(TxDNotificador, Notificando),dini_Set("ZNS.ini","notificar",string);return 1;}
if(tempo > 0){SetTimer("NotRemoveEx", tempo, 0);}
TextDrawSetString(TxDNotificador, string);
dini_Set("ZNS.ini","notificar",string);
return 1;
}

forward NotificarBlink();
public NotificarBlink()
{
if(NotBlinker == true){
NotBlinker = false;
TextDrawHideForAll(TxDNotificador);
}else{
NotBlinker = true;
TextDrawShowForAll(TxDNotificador);}
return 1;
}



forward Notificar(string[]);
public Notificar(string[])
{
format(Notificando, sizeof(Notificando), "%s",string);
TextDrawSetString(TxDNotificador, string);
dini_Set("ZNS.ini","notificar",string);
return 1;
}

forward NotRemoveEx();
public NotRemoveEx()
{
TextDrawSetString(TxDNotificador, Notificando);
return 1;
}

forward NotRemove();
public NotRemove()
{
TextDrawSetString(TxDNotificador, "   ");
return 1;
}

public OnPlayerText(playerid, text[])
{

if(PlayerDados[playerid][LocalSpawn] == true){
	new String[300];
    if(strlen(text) == strlen("aqui"))
    {
    	new Float:X,
			Float:Y,
			Float:Z;
		GetPlayerPos(playerid, X, Y, Z);
		format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
		format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", DOF2_GetInt(String, "Lider"));
		DOF2_SetFloat(String, "SpawnX", X);
		DOF2_SetFloat(String, "SpawnY", Y);
		DOF2_SetFloat(String, "SpawnZ", Z);
		DOF2_SaveFile();
		PlayerDados[playerid][LocalSpawn] = false;
		DialogGang(playerid);
		SendClientMessage(playerid, COLOUR_INFORMACAOGANG, "[CLA]: Local do spawn setado com sucesso!");
		return 0;
	}
	if(strlen(text) == strlen("cancelar"))
	{
	    PlayerDados[playerid][LocalSpawn] = false;
	    DialogGang(playerid);
	    return 0;
	}
	SendClientMessage(playerid, COLOUR_INFORMACAOGANG, "[CLA]: Use 'aqui' ou 'cancelar' para selecionar o local de spawn");
	return 0;
}

new chat[128]; format(chat, sizeof(chat), "%s",text);
if(text[0] == ';'){ChatProximo(playerid, COLOUR_CHATPROX, text[1]);return 0;}

// Chat em GRUPO
if(text[0] == '.')
{
	//Jogador não tem grupo
	if(GetPVarInt(playerid,"GrupoChat") == -0)
	{
	SendClientMessage(playerid,COLOUR_INFORMACAO,"** Usar um ponto antes do chat significa chat em grupo");
	SendClientMessage(playerid,COLOUR_INFORMACAO,"** Para criar ou entrar em um grupo use: {FFFFFF}/grupo <id do grupo>");
	SendClientMessage(playerid,COLOUR_INFORMACAO,"** Somente os membros do grupo verão as mensagens!");
	return 0;
	}

	new GrupoChatSTR[170],pname[100];
	GetPlayerName(playerid, pname, MAX_PLAYER_NAME);

	//Para os admins lerem - Grupo anonimo = 5876312
	if(GetPVarInt(playerid,"GrupoChat") != 3816317)
	{
 		for(new i; i < GetMaxPlayers(); i++)
 		{
 			if(IsPlayerConnected(i))
		 	{
				if(CallRemoteFunction("GetPlayerAdminLevel","i",i) >= 4)
				{
					if(GetPVarInt(i,"GrupoChat") != GetPVarInt(playerid,"GrupoChat"))
					{
					format(GrupoChatSTR, sizeof(GrupoChatSTR), "[%i]: %s (%i): %s", GetPVarInt(playerid,"GrupoChat"), pname, playerid, text[1]);
					SendClientMessage(i, 0xFF9900AA, GrupoChatSTR);
					}
				}
			}
		}
	}

	//Enviar mensagem para o grupo
	for(new i; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarInt(i,"GrupoChat") == GetPVarInt(playerid,"GrupoChat"))
			{
			format(GrupoChatSTR, sizeof(GrupoChatSTR), "{FFFF00}[%i]:{00FFFF} %s (%i): {FFFFFF}%s", GetPVarInt(playerid,"GrupoChat"), pname, playerid, text[1]);
			SendClientMessage(i, COLOUR_INFORMACAO, GrupoChatSTR);
			PlayerPlaySound(i,1056,0.0,0.0,0.0);
			}
		}
	}

return 0;
}


//Chat com ID
new string[128];
format(string,sizeof(string),"(%i): %s",playerid,text);
SendPlayerMessageToAll(playerid,string);
SetPlayerChatBubble(playerid, chat, COLOUR_BRANCO, 20.0, 10000);
/*
if(PlayerDados[playerid][Membro] == 0){
    format(string,sizeof(string),"(%i): %s",playerid,text);
	SendPlayerMessageToAll(playerid,string);
	SetPlayerChatBubble(playerid, chat, COLOUR_BRANCO, 20.0, 10000);
}else if(PlayerDados[playerid][Cargo] == 1){
	format(string,sizeof(string),"%s (%i) - [Aprendiz]: {FFFFFF}%s ",Nome(playerid), playerid,text);
	SendClientMessageToAll(GetPlayerColor(playerid),string);
}else if(PlayerDados[playerid][Cargo] == 2){
	format(string,sizeof(string),"%s (%i) - [Aprendiz]: {FFFFFF}%s ",Nome(playerid),playerid,text);
	SendClientMessageToAll(GetPlayerColor(playerid),string);
}else if(PlayerDados[playerid][Cargo] == 3){
	format(string,sizeof(string),"%s (%i) - [Matador]: {FFFFFF}%s ",Nome(playerid),playerid,text);
	SendClientMessageToAll(GetPlayerColor(playerid),string);
}else if(PlayerDados[playerid][Cargo] == 4){
	format(string,sizeof(string),"%s (%i) - [Recruter]: {FFFFFF}%s ",Nome(playerid),playerid,text);
	SendClientMessageToAll(COLOUR_DICA,string);
}else if(PlayerDados[playerid][Cargo] == 5){
	format(string,sizeof(string),"%s (%i) - [Dono da Gang]: {FFFFFF}%s ",Nome(playerid),playerid,text);
	SendClientMessageToAll(GetPlayerColor(playerid),string);
}*/
return 0;
}

forward RemoverProcuradoSpree(playerid);
public RemoverProcuradoSpree(playerid)
{
Spree[playerid] = 0;
SetPlayerWantedLevel(playerid, 0);
return 1;
}

stock CancelarX1C(playerid)
{
	for(new i; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i))
		{
			if(ChamadoParaX1Por[i] == playerid)
			{
			ChamadoParaX1Por[i] = -1;
			CX1Tipo[playerid] = 0;
			}
		}
	}
return 1;
}

stock CX1Agendado(playerid)
{
	for(new i; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i))
		{
			if(ChamadoParaX1Por[i] == playerid)
			{
			return i;
			}
		}
	}
return -1;
}

dcmd_x1c(playerid,params[]){
if(!IsPlayerSpawned(playerid)){return 1;}
if(Anova == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Esta arena foi temporariamente desativada para manutenção");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(CX1Agendado(playerid) >= 0){
SendClientMessage(CX1Agendado(playerid),COLOUR_INFORMACAO,"[INFO]: Seu oponente cancelou o X1!");
CancelarX1C(playerid);
SendClientMessage(playerid,COLOUR_INFORMACAO,"[INFO]: Seu convite foi cancelado!");return 1;}
if(TickCounter - X1CTick[playerid] < 30) return SendClientMessage(playerid,COLOUR_AVISO,"[AVISO]: Você só pode enviar um convite p/ X1 por minuto!");
if(!strlen(params)) return SendClientMessage(playerid, COLOUR_ERRO,"[USO]: Convidar algúem para um X1: {FFFFFF}/X1C <id> {C0C0C0}<run/walk>");
new tmp[128], Index;
tmp = strtok(params,Index); //Parametro 1 String
new param = strval(tmp); //Parametro 1 Int
new PosString = strlen(tmp) + 1; //Parametro 2 String
if(!IsNumeric(tmp)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: ID Inválida");
if(!IsPlayerConnected(param)) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[10]);
if(param == playerid) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Tá de brincadeira né?");
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new string[100],string2[100];
X1CTick[playerid] = TickCounter;
CX1Tipo[param] = 1;
if(strlen(params[PosString]) > 0){
if(strcmp("r", params[PosString], true, 10) == 0)			CX1Tipo[param] = 1;
if(strcmp("run", params[PosString], true, 10) == 0)			CX1Tipo[param] = 1;
if(strcmp("running", params[PosString], true, 10) == 0) 	CX1Tipo[param] = 1;
if(strcmp("w", params[PosString], true, 10) == 0)			CX1Tipo[param] = 2;
if(strcmp("wk", params[PosString], true, 10) == 0)			CX1Tipo[param] = 2;
if(strcmp("walk", params[PosString], true, 10) == 0) 		CX1Tipo[param] = 2;
if(strcmp("walking", params[PosString], true, 10) == 0) 	CX1Tipo[param] = 2;}
new pname[MAX_PLAYER_NAME],pname2[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, sizeof(pname));
GetPlayerName(param, pname2, sizeof(pname2));
new X1TipoSTR[20];
if(CX1Tipo[param] == 1) X1TipoSTR = "RUNNING";
if(CX1Tipo[param] == 2) X1TipoSTR = "WALKING";
format(string, sizeof(string), "[INFO]: %s (%i) te desafiou para um X1 %s! Aceitar: {FFFFFF} /gx1", pname, playerid, X1TipoSTR);
format(string2, sizeof(string2), "[INFO]: Você desafiou %s (%i) para um X1 %s! Se ele (a) aceitar o duelo começará!", pname2, param, X1TipoSTR);
ChamadoParaX1Por[param] = playerid;
SendClientMessage(param, COLOUR_INFORMACAO, string);
SendClientMessage(playerid, COLOUR_INFORMACAO, string2);
ProgramarAntiFlood(playerid);
return 1;}

dcmd_enquete(playerid,params[]) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) >= 2){
new StringEnquete[128],StringEnquete2[128];
new EnqueteMsg[128],EnqueteMsgIndex; EnqueteMsg = strtok(params,EnqueteMsgIndex);
if(!strlen(params)) return SendClientMessage(playerid, Cinza, "Uso: /Enquete [Enquete/Frase] | Encerrar");
if(!strcmp(params,"encerrar",true)) {
if(Enquete == true) {
TotalEnqueteVotos = EnqueteVotosSim+EnqueteVotosNao;
new AdministradorNick[MAX_PLAYER_NAME]; GetPlayerName(playerid, AdministradorNick, sizeof(AdministradorNick));
SendClientMessageToAll(Branco, "=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=");
format(StringEnquete, sizeof(StringEnquete), "> Administrador(a) %s encerrou a Enquete.", AdministradorNick);
SendClientMessageToAll(Roxo, StringEnquete);
SendClientMessageToAll(Branco, " ");
SendClientMessageToAll(VerdeClaro, EnqueteMensagem);
SendClientMessageToAll(Branco, " ");
format(StringEnquete2, sizeof(StringEnquete2), "Votos: %d     |     Sim: %d (%d)      |     Não: %d (%d)", TotalEnqueteVotos, EnqueteVotosSim, EnqueteVotosSim*100/TotalEnqueteVotos, EnqueteVotosNao, EnqueteVotosNao*100/TotalEnqueteVotos);
SendClientMessageToAll(Amarelo, StringEnquete2);
SendClientMessageToAll(Branco, "=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=");
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i))
{
new SoundX,SoundY,SoundZ; PlayerPlaySound(i, 1057, SoundX, SoundY, SoundZ);
EnqueteVotou[i] = false;
}}
EnqueteVotosSim = 0;
EnqueteVotosNao = 0;
Enquete = false;
return 1;
} else return SendClientMessage(playerid, Vermelho, "[ERRO]: Não há nenhuma enquete aberta.");
}
else
if(Enquete == false) {
new AdministradorNick[MAX_PLAYER_NAME]; GetPlayerName(playerid, AdministradorNick, sizeof(AdministradorNick));
SendClientMessageToAll(Branco, "=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=");
format(StringEnquete, sizeof(StringEnquete), "> Administrador(a) %s iniciou uma Enquete.", AdministradorNick);
SendClientMessageToAll(Roxo, StringEnquete);
SendClientMessageToAll(Branco, " ");
format(StringEnquete2, sizeof(StringEnquete2), "Enquete: %s", params);
SendClientMessageToAll(VerdeClaro, StringEnquete2);
SendClientMessageToAll(Branco, " ");
SendClientMessageToAll(Amarelo, "Use para votar:      /Sim      &      /Nao.");
SendClientMessageToAll(Branco, "=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=");
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i))
{
new SoundX,SoundY,SoundZ; PlayerPlaySound(i, 1056, SoundX, SoundY, SoundZ);
EnqueteVotou[i] = false;
}}
EnqueteVotosSim = 0;
EnqueteVotosNao = 0;
Enquete = true;
format(EnqueteMensagem, sizeof(EnqueteMensagem), "Enquete: %s", params);
format(EnqueteMensagemDialog, sizeof(EnqueteMensagemDialog), "Enquete: %s\n\nSelecione uma opção de voto.", params);
return 1;
} else return SendClientMessage(playerid, Vermelho, "[ERRO]: Há uma enquete em andamento.");
} else return 0;
}

dcmd_sim(playerid,params[]) {
#pragma unused params
if(Enquete == true) {
if(EnqueteVotou[playerid] == false) {
EnqueteVotou[playerid] = true;
EnqueteVotosSim++;
new SoundX,SoundY,SoundZ; PlayerPlaySound(playerid, 1057, SoundX, SoundY, SoundZ);
SendClientMessage(playerid, Amarelo, "> Seu voto \"sim\" foi registrado, obrigado por participar.");
} else return SendClientMessage(playerid, Vermelho, "[ERRO]: Você já votou, aguarde o resultado da enquete.");
} else return SendClientMessage(playerid, Vermelho, "[ERRO]: Não há nenhuma enquete aberta.");
return 1;
}

dcmd_nao(playerid,params[]) {
#pragma unused params
if(Enquete == true) {
if(EnqueteVotou[playerid] == false) {
EnqueteVotou[playerid] = true;
EnqueteVotosNao++;
new SoundX,SoundY,SoundZ; PlayerPlaySound(playerid, 1057, SoundX, SoundY, SoundZ);
SendClientMessage(playerid, Amarelo, "> Seu voto \"não\" foi registrado, obrigado por participar.");
} else return SendClientMessage(playerid, Vermelho, "Erro: Você já votou, aguarde o resultado da enquete.");
} else return SendClientMessage(playerid, Vermelho, "Erro: Não há nenhuma enquete aberta.");
return 1;
}

dcmd_minharadio(playerid,params[]){
if(!strlen(params)) return SendClientMessage(playerid, COLOUR_ERRO,"Uso: /minharadio <URL>");
if(strlen(params) < 5) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: URL de rádio online muito curta!");
PlayAudioStreamForPlayer(playerid, params);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Sua URL tentara ser tocada pelo jogo!");
return 1;}

dcmd_findban(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!strlen(params)) return SendClientMessage(playerid, COLOUR_ERRO,"Uso: /findban <nick/adm/data/etc...>");
if(strlen(params) < 3) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Palavra-chave muito curta!");
if(strlen(params) > 150) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Palavra-chave muito grande!");
new Buffer[180],str[128],Results;
new File:BanLog = fopen("ladmin/logs/BanLog.txt", io_read);
if(flength(BanLog) > 512000) //500KB
{
fclose(BanLog);
SendClientMessage(playerid,0xFF0000FF,"[ERRO]: O arquivo de log não pode ser pesquisado por passar do tamanho limite (500KB)");
return 1;
}
fseek(BanLog, seek_start);
format(str, sizeof(str), "[INFO]: Pesquisando no BanLog.txt: {C0C0C0}%s", params);
SendClientMessage(playerid,COLOUR_INFORMACAO,str);
while(fread(BanLog, Buffer))
{
	if(strfind(Buffer, params, true) != -1)
	{
	Results++;
	if(Results < 5) SendClientMessage(playerid,0xFFFFFFFF,Buffer);
	}
}
format(str, sizeof(str), "[INFO]: %i resultados encontrados para: {C0C0C0}%s", Results, params);
SendClientMessage(playerid,COLOUR_INFORMACAO,str);
fclose(BanLog);
return 1;}

dcmd_tpick(playerid,params[]) {

    if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não tem permissão para isso");
	if(!strlen(params)) return SendClientMessage(playerid,COLOUR_ERRO, "USO: /tpick <tempo>");
    if(!IsNumeric(params)) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO] Digite um número inteiro válido");

	new tempo_min = strval(params);
	new tempo_sec = tempo_min*60;
	new tempo_ms = tempo_sec*1000;

	if(tempo_min == 0){
	KillTimer(AutoDeletarPickTimer);
	SendClientMessage(playerid,COLOUR_INFORMACAO, "[INFO]: Os pickups não serão deletados automaticamentes!");
	return 1;}

	if(tempo_min < 1) return SendClientMessage(playerid,COLOUR_ERRO, "[ERRO]: Tempo inválido, Especifique em minutos");

	KillTimer(AutoDeletarPickTimer);
	AutoDeletarPickTimer = SetTimer("DeletarPick",tempo_ms, 0);

	return 1;
}

dcmd_sortear(playerid,params[]) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 1) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
new quantia=strval(params);
new limite;
new string[128],string2[128],string3[128];
new PlayersOnline;
new lmsorteio;
if(!strlen(params)){SendClientMessage(playerid, COLOUR_ERRO, "Uso: /sortear <quantia>");return 1;}
if(!IsNumeric(params)){SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Digite um valor numérico, sua anta!");return 1;}
if(quantia < 1){SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Quantia muito baixa!");return 1;}
switch (CallRemoteFunction("GetPlayerAdminLevel","i",playerid)){
case 1: limite = 10000,lmsorteio = 5;
case 2: limite = 50000,lmsorteio = 10;
case 3: limite = 100000,lmsorteio = 20;
case 4: limite = 250000,lmsorteio = 40;
case 5: limite = 10000000,lmsorteio = 999999999;
case 6: limite = 10000000,lmsorteio = 999999999;
case 7: limite = 10000000,lmsorteio = 999999999;}
for(new i; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i)) PlayersOnline++;
if(PlayersOnline < 5) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: O servidor deve ter no mínimo 5 players online");
if(quantia > limite){
format(string, sizeof(string), "[ERRO]: O limite de sorteio para seu nível de ADM é $%i", limite);
SendClientMessage(playerid, COLOUR_ERRO, string);
return 1;}
if(SorteiosFeitos[playerid] >= lmsorteio){
format(string, sizeof(string), "[ERRO]: O limite de sorteios realizados para seu nível ADM são de %i por sessão", lmsorteio);
SendClientMessage(playerid, COLOUR_ERRO, string);
return 1;}
if(CallRemoteFunction("GetPlayerCash", "i", playerid) < quantia) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não possui dinheiro suficiente!");
new NomeDoSortudo[MAX_PLAYER_NAME];
new NomeDoADM[MAX_PLAYER_NAME];
new sortudo;
new Interations;
for(;;){
Interations++;
sortudo = random(GetMaxPlayers());
if(IsPlayerConnected(sortudo) && sortudo != playerid) break;
if(Interations > GetMaxPlayers()*1000){sortudo = INVALID_PLAYER_ID;break;}}
if(sortudo == INVALID_PLAYER_ID) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: O sorteio falhou, tente novamente (Anti loop infinito)");
GetPlayerName(sortudo, NomeDoSortudo, sizeof(NomeDoSortudo));
GetPlayerName(playerid, NomeDoADM, sizeof(NomeDoADM));
format(string, sizeof(string), "[SORTEIO]: O sorteio de $%i realizado por %s teve %s como ganhador!", quantia,NomeDoADM,NomeDoSortudo,NomeDoSortudo);
format(string2, sizeof(string2), "~g~VOCE GANHOU O SORTEIO!~n~~w~$%i", quantia);
format(string3, sizeof(string3), "[AVISO]: O servidor fez %i sorteio (s) aleatório (s) até achar um resultado válido (ID online)", Interations);
CallRemoteFunction("GivePlayerCash", "ii", playerid, -quantia);
CallRemoteFunction("GivePlayerCash", "ii", sortudo, quantia);
SorteiosFeitos[playerid]++;
SendClientMessageToAll(COLOUR_INFORMACAO, string);
SendClientMessage(playerid, COLOUR_AVISO, string3);
GameTextForPlayer(sortudo,string2,5000,3);
return 1;
}

dcmd_sortearscore(playerid,params[]) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 6) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
new quantia=strval(params);
new limite;
new string[128],string2[128],string3[128];
new PlayersOnline;
new lmsorteio;
if(!strlen(params)){SendClientMessage(playerid, COLOUR_ERRO, "Uso: /sortearscore <quantia>");return 1;}
if(!IsNumeric(params)){SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Digite um valor numérico, sua anta!");return 1;}
if(quantia < 1){SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Quantia muito baixa!");return 1;}
switch (CallRemoteFunction("GetPlayerAdminLevel","i",playerid)){
case 1: limite = 100,lmsorteio = 5;
case 2: limite = 200,lmsorteio = 10;
case 3: limite = 300,lmsorteio = 20;
case 4: limite = 400,lmsorteio = 40;
case 5: limite = 500,lmsorteio = 999999999;
case 6: limite = 10000000,lmsorteio = 999999999;
case 7: limite = 10000000,lmsorteio = 999999999;}
for(new i; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i)) PlayersOnline++;
if(PlayersOnline < 5) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: O servidor deve ter no mínimo 5 players online");
if(quantia > limite){
format(string, sizeof(string), "[ERRO]: O limite de sorteio para seu nível de ADM é $%i", limite);
SendClientMessage(playerid, COLOUR_ERRO, string);
return 1;}
if(SorteiosFeitos[playerid] >= lmsorteio){
format(string, sizeof(string), "[ERRO]: O limite de sorteios realizados para seu nível ADM são de %i por sessão", lmsorteio);
SendClientMessage(playerid, COLOUR_ERRO, string);
return 1;}
new NomeDoSortudo[MAX_PLAYER_NAME];
new NomeDoADM[MAX_PLAYER_NAME];
new sortudo;
new Interations;
for(;;){
Interations++;
sortudo = random(GetMaxPlayers());
if(IsPlayerConnected(sortudo) && sortudo != playerid) break;
if(Interations > GetMaxPlayers()*1000){sortudo = INVALID_PLAYER_ID;break;}}
if(sortudo == INVALID_PLAYER_ID) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: O sorteio falhou, tente novamente (Anti loop infinito)");
GetPlayerName(sortudo, NomeDoSortudo, sizeof(NomeDoSortudo));
GetPlayerName(playerid, NomeDoADM, sizeof(NomeDoADM));
format(string, sizeof(string), "[SORTEIO de SCORE]: O sorteio de SCORE %i realizado por %s teve %s como ganhador!", quantia,NomeDoADM,NomeDoSortudo,NomeDoSortudo);
format(string2, sizeof(string2), "~g~VOCE GANHOU O SORTEIO!~n~~w~%i DE SCORE", quantia);
format(string3, sizeof(string3), "[AVISO]: O servidor fez %i sorteio (s) aleatório (s) até achar um resultado válido (ID online)", Interations);
SetPlayerScore(sortudo,GetPlayerScore(sortudo)+quantia);
SorteiosFeitos[playerid]++;
SendClientMessageToAll(COLOUR_INFORMACAO, string);
SendClientMessage(playerid, COLOUR_AVISO, string3);
GameTextForPlayer(sortudo,string2,5000,3);
return 1;
}

dcmd_grupo(playerid,params[]){
if(!strlen(params)) return SendClientMessage(playerid, COLOUR_ERRO,"USO: /grupo <id do grupo>");
if(!IsNumeric(params)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: ID de grupo inválida (Use de 1 até 99999999)");
new param=strval(params);
if(param >= 99999999 || param < 1) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: ID de grupo inválida");
new string[128];
format(string, sizeof(string), "*** Você acabou de entrar no grupo: {FFFFFF}%i", param);
SendClientMessage(playerid, COLOUR_INFORMACAO, string);
SendClientMessage(playerid, COLOUR_INFORMACAO, "** Para usar o chat do grupo use o . (ponto) antes da frase!");
SendClientMessage(playerid, COLOUR_INFORMACAO, "** Para sair do grupo digite: {FFFFFF}/gruposair");
SendClientMessage(playerid, COLOUR_INFORMACAO, "** Para saber quantos players online tem no grupo: {FFFFFF}/grupoons");
SetPVarInt(playerid, "GrupoChat", param);
return 1;}

dcmd_testarsom(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!strlen(params)) return SendClientMessage(playerid, COLOUR_ERRO,"USO: /testarsom <id do som>");
if(!IsNumeric(params)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: ID de som inválida");
new param=strval(params);
new string[128];
new Float:X, Float:Y, Float:Z;
GetPlayerPos(playerid, X, Y, Z);
PlayerPlaySound(playerid, param, X, Y, Z);
format(string, sizeof(string), "[INFO]: Você acabou de testar o som em você: {FFFFFF}%i", param);
SendClientMessage(playerid, COLOUR_INFORMACAO, string);
return 1;}

dcmd_tocarsom(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!strlen(params)) return SendClientMessage(playerid, COLOUR_ERRO,"USO: /tocarsom <id do som>");
if(!IsNumeric(params)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: ID de som inválida");
new param=strval(params);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"TOCARSOM");
new string[128];
for(new i; i < GetMaxPlayers(); i++)
{
	if(IsPlayerConnected(i))
	{
	PlayerPlaySound(i, param, 0, 0, 0);
	}
}
format(string, sizeof(string), "[INFO]: Você acabou de tocar para todos o som: {FFFFFF}%i", param);
SendClientMessage(playerid, COLOUR_INFORMACAO, string);
return 1;}

dcmd_tocarmusica(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!strlen(params)) return SendClientMessage(playerid, COLOUR_ERRO,"USO: /tocarmusica <URL>");
if(strlen(params) < 5) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: URL de rádio online muito curta!");
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"TOCARMUSICA");
for(new i=0; i<MAX_PLAYERS; i++)
    {
      PlayAudioStreamForPlayer(i, params);
 }
new string[1000];
new pname[MAX_PLAYER_NAME];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{00FF22}[INFO]: O administrador {FFFFFF}%s {00FF22}colocou uma musica para todos! Para desligar a musica: {FFFFFF}/OFF", pname);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
return 1;}

dcmd_dsss(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!strlen(params)) return SendClientMessage(playerid, COLOUR_ERRO,"USO: /darsss <ID>");
if(!IsNumeric(params)) return SendClientMessage(playerid,COLOUR_ERRO,"ERRO: ID Invalida");
new param=strval(params);
if(!IsPlayerConnected(param)) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[10]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"DSSS");
new sss[128],sss2[128];new pname[MAX_PLAYER_NAME],pname2[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, sizeof(pname));
GetPlayerName(param, pname2, sizeof(pname2));

if(StuntSuperSpeed[param] == false)
{
format(sss, sizeof(sss), "[INFO]: Administrador %s te deu poderes Super Stunt Speed!", pname);
format(sss2, sizeof(sss2), "Stunt Super Speed foi dado ao jogador %s (%i)", pname2,param);
SendClientMessage(playerid, COLOUR_INFORMACAO,sss2);
SendClientMessage(param, COLOUR_INFORMACAO,sss);
SendClientMessage(param, COLOUR_INFORMACAO, "[INFO]: Para usar os poderes, use o clique direito do mouse e a tecla CTRL! (Em um veículo)");
StuntSuperSpeed[param] = true;
}else{
format(sss2, sizeof(sss2), "Stunt Super Speed foi removido do jogador %s (%i)", pname2,param);
SendClientMessage(playerid, COLOUR_INFORMACAO,sss2);
StuntSuperSpeed[param] = false;}

return 1;}

/*dcmd_ga(playerid,params[]){
	new Texto[128];
	new String[300];
    format(String, sizeof(String), "LAGANGS/Players/%d.ini", PlayerDados[playerid][Cargo]);
    DOF2_GetInt(String, "Cargo", PlayerDados[playerid][Cargo]);
	if(PlayerDados[playerid][Cargo] == 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não pertence à nenhum clã!");
	if(sscanf(params, "s", Texto)) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Use {FFFFFF}/ga [texto] {FF0000}para mandar uma mensagem para todos do cla.");
    if(PlayerDados[playerid][Cargo] == 1) CargoNome = "Aprendiz";
	if(PlayerDados[playerid][Cargo] == 2) CargoNome = "Aprendiz";
	if(PlayerDados[playerid][Cargo] == 3) CargoNome = "Matador";
	if(PlayerDados[playerid][Cargo] == 4) CargoNome = "Recruter";
	if(PlayerDados[playerid][Cargo] == 5) CargoNome = "Dono do Cla";
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(PlayerDados[i][Membro] == PlayerDados[playerid][Membro])
	    {
			format(String, sizeof(String), "(%s) | %s (%i): {FFFFFF}%s", CargoNome, Nome(playerid), playerid ,Texto);
			SendClientMessage(i, ArquivoGangHex(playerid, "CorG"), String);
		}
	}
	return 1;
}*/

/*dcmd_membros(playerid,params[]){
#pragma unused params
    if(!IsPlayerSpawned(playerid)){return 1;}
	if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
	if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode criar um cla agora!");
	if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
	if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
	if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
	if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
	if(PlayerDados[playerid][Membro] == 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não faz parte de nenhum cla!");

	new String[300];
	for(new i,a = GetMaxPlayers();i < a;i++)	{
	    if(IsPlayerConnected(i)){
		    if(PlayerDados[i][Membro] == PlayerDados[playerid][Membro])	 {
		  		if(PlayerDados[i][Cargo] == 1){ CargoNome = "Aprendiz";}
				if(PlayerDados[i][Cargo] == 2){ CargoNome = "Aprendiz";}
				if(PlayerDados[i][Cargo] == 3){ CargoNome = "Matador";}
				if(PlayerDados[i][Cargo] == 4){ CargoNome = "Recruter";}
				if(PlayerDados[i][Cargo] == 5){ CargoNome = "Dono do Cla";}
				format(String, sizeof(String), "%s{FFFFFF} | %s (Cargo %d)\n", Nome(i), CargoNome, PlayerDados[i][Cargo]);
				SendClientMessage(playerid, ArquivoGangHex(playerid, "CorG"), String);
   			}
		}
	}
	return 1;
}*/

dcmd_hmc(playerid,params[]) {
if(!IsPlayerSpawned(playerid)) return 1;
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
if(Arena2[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
new tmp[128],Index; tmp = strtok(params,Index);
if(!strlen(params))
{
SendClientMessage(playerid, COLOUR_AVISO, "[INFO]: Uso: /HMC [Código HEX]");
SendClientMessage(playerid, COLOUR_AVISO, "[DICA]: Utilize o site \"www.colorpicker.com\" para obter códigos.");
return 1;
}
if(strlen(params)!=6)
{
SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O Código digitado é inválido");
SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Visite \"www.colorpicker.com\" e faça sua cor");
return 1;
}

new StringCor[20]; format(StringCor, sizeof(StringCor), "0x%sFF", tmp);
new Cor = HexToInt(StringCor);
cor[playerid] = Cor;
SetPlayerColor(playerid, Cor);
SendClientMessage(playerid, GetPlayerColor(playerid), "[INFO]: Sua COR foi mudada. Ficará salva em sua conta");
SendClientMessage(playerid, GetPlayerColor(playerid), "[INFO]: Digite /rmc para não usar mais essa cor.");
SendClientMessage(playerid, GetPlayerColor(playerid), "[AVISO]: É proibido usar cores muito escuras (Sujeito a KICK)");
PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
return 1;
}

/*dcmd_ganghmc(playerid,params[]) {
	if(!IsPlayerSpawned(playerid)) return 1;
	if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
	if(Arena2[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
	if(PlayerDados[playerid][Membro] == 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pertence a nenhum CLA!");
	if(PlayerDados[playerid][Lider] == 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Somente o lider pode definir a cor do CLA!");
	new tmp[128],Index; tmp = strtok(params,Index);
	if(!strlen(params)){
		SendClientMessage(playerid, COLOUR_AVISO, "[INFO]: Uso: /CLAHMC [Código HEX]");
		SendClientMessage(playerid, COLOUR_AVISO, "[DICA]: Utilize o site \"www.colorpicker.com\" para obter códigos.");
		return 1;
	}
	if(strlen(params)!=6){
		SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O Código digitado é inválido");
		SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Visite \"www.colorpicker.com\" e faça sua cor");
		return 1;
	}

	new StringCor[20]; format(StringCor, sizeof(StringCor), "0x%sFF", tmp);
	new Cor = HexToInt(StringCor);
	for(new i; i < GetMaxPlayers(); i++){
		if(IsPlayerConnected(i)) {
            if(PlayerDados[i][Membro] == PlayerDados[playerid][Lider]){
            	cor[i] = Cor;
                SetPlayerColor(i, Cor);
                SetarCorHmc(i, Cor);
				SendClientMessage(i, GetPlayerColor(playerid), "[INFO]: A COR do CLA foi mudada. Ficará salva nas contas!");
				SendClientMessage(i, GetPlayerColor(playerid), "[AVISO]: É proibido usar cores muito escuras (Sujeito a KICK)");
				PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
			}
		}
	}
return 1;
}*/

dcmd_tela2(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(StringTXTBugado(params)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Seu texto está com erros e foi bloqueado para evitar crash's");
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"TELA2");new string[128];
format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~h~%s", params);
GameTextForAll(string,4000,3);
return 1;}

dcmd_aceitar(playerid,params[]){
	new id;
	if(sscanf(params,"d",id)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Uso: /aceitar [ID]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO:] ID Invalido!");
	if(Duel[id] != 999) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Duel ja começou ou não existe!");
	if(id == playerid) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não pode aceitar seu proprio duel");
	if((Duel[playerid] != 998 && Duel[id] != 998) && (Duel[id] == playerid)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você já está em um DUEL.");

	if(!IsPlayerSpawned(playerid)){return 1;}
	if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
	if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
	if(LifeBaixo(playerid)) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[6]);
	if(GetPlayerInterior(playerid) != 0 && DuelArena[playerid] == false) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[7]);
	if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
	if(Arena[playerid] == 1 && DuelArena[playerid] == false) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[9]);
	if(CallRemoteFunction("LocalInvalidoParaTeleporte","i",playerid) && GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[2]);
	if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);

    Arena[id] = 1;
    Arena[playerid] = 1;
    DuelArena[id] = true;
	new a[500];
	format(a,sizeof a,"[DUEL] {FFFFFF}%s {FF0000}aceitou duel com {FFFFFF}%s!",GetName(playerid),GetName(id));
	SendClientMessageToAll(COLOUR_INFORMACAO,a);
	Duel[id] = playerid;
	Duel[playerid] = id;
	SetPlayerVirtualWorld(playerid,id);
	SetPlayerInterior(playerid,1);
	SetPlayerPos(playerid,1376.0934,-22.0428,1000.9268);
	SetPlayerFacingAngle(playerid,271.4);
	SetPlayerInterior(id,1);
	SetPlayerPos(id,1403.6039,-20.7303,1000.9115);
	SetPlayerFacingAngle(id,92.4);
	ContagemDuel(playerid,id);
	return 1;
}

dcmd_eventonome(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!strlen(params)) return SendClientMessage(playerid,COLOUR_ERRO,"USO: /eventonome <nome do seu evento>");
if(strlen(params) > 20) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: O nome é muito grande!");
if(strlen(params) < 2) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: O nome é muito pequeno!");
if(StringTXTBugado(params)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Seu texto está com erros e foi bloqueado para evitar crash's");
new string[128];
format(EventoNome, sizeof(EventoNome), "%s", params);
format(string, sizeof(string), "[INFO]: O nome do evento foi definido para: {FFFFFF}%s", EventoNome);
SendClientMessage(playerid,COLOUR_INFORMACAO,string);
return 1;}

dcmd_eventotela(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(StringTXTBugado(params)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Seu texto está com erros e foi bloqueado para evitar crash's");
if(EventoAtivo != 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Sem eventos no momento");
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"EVENTOTELA");new string[128];
format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~h~%s", params);
for(new i; i < GetMaxPlayers(); i++)
{
	if(IsPlayerConnected(i))
	{
		if(NoEvento[i] == 1)
		{
		GameTextForPlayer(i, string,4000,3);
		}
	}
}
GameTextForPlayer(playerid, string,4000,3);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: A mensagem foi enviada para você e todos do evento!");
return 1;}

dcmd_adm(playerid,params[]){
if(!strlen(params)) return SendClientMessage(playerid, COLOUR_ERRO,"Uso: /adm <mensagem>");
if(MensagemADMAtivado == 0) return SendClientMessage(playerid, COLOUR_ERRO,"[ERRO]: O sistema de mensagens aos administradores esta temporariamente desativado");
if(TickCounter - ADMTick[playerid] < 30) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você só pode enviar uma mensagem a administração a cada 30 segundos");
if(strlen(params) < 5) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Mensagem muito curta! Use no mínimo 5 caracteres!");
if(strlen(params) > 80) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Mensagem muito longa! Use no máximo 80 caracteres!");
new string[140], pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, sizeof(pname));
ADMTick[playerid] = TickCounter;
format(string, sizeof(string), "[ADM]: Mensagem de %s (%i): {C1C1C1}%s", pname, playerid, params);
CallRemoteFunction("MessageToAdmins","is",COLOUR_AVISO,string);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Sua mensagem foi enviada para todos os administradores online!");
return 1;}

dcmd_setsvfull(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
new string[128];
if(!strlen(params)){
format(string, sizeof(string), "[INFO]: Quando o servidor alcançar a quantidade de slots %i, começará a kickar players inativos", SvFullValue);
SendClientMessage(playerid, COLOUR_CINZA,string);
SendClientMessage(playerid, COLOUR_ERRO,"[INFO]: Para alterar: /setsvfull <SLOTS>");
return 1;}
if(!IsNumeric(params)) return SendClientMessage(playerid,COLOUR_ERRO,"ERRO: Slots inválidos");
new param=strval(params);
if(GetMaxPlayers() - param >= 6) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Número de slots muito baixo em relação a capacidade do servidor");
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"SETSVFULL");
SvFullValue = param;
dini_IntSet("ZNS.ini","SvFullValue", SvFullValue);
format(string, sizeof(string), "[INFO]: Quando o servidor alcançar a quantidade de slots %i começará a kickar players inativos", SvFullValue);
SendClientMessage(playerid, COLOUR_INFORMACAO, string);
return 1;}

dcmd_pvcescolher(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
new pvcesc = strval(params);
if(!strlen(params)) return SendClientMessage(playerid, COLOUR_ERRO, "USO: /PVCESCOLHA [0~4]");
if(PVC_EmProgresso == 1 || PVC_Lobby == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O combate PVC já está em execução");
KillTimer(PVC_Timer);
PVC_Tipo = pvcesc;
if(PVC_Tipo>=0 && PVC_Tipo<=3){
	PVC_Escolher = true;
	PVC_DefLobby(); // FAZ O SWITCH RANDOM
}
return 1;}

dcmd_eamescolher(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
new pvcesc = strval(params);
if(!strlen(params)) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: USO: /EAMESCOLHA [0~2]");
if(EAM_EmProgresso == 1 || EAM_Lobby == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: EAM já está em execução");
KillTimer(EAM_Timer);
EAM_Tipo = pvcesc;
if(EAM_Tipo>=0 && EAM_Tipo<=2){
	EAM_Escolher = true;
	EAM_DefLobby(); // FAZ O SWITCH RANDOM
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[EAM]: Voce iniciou!");
}else{
    SendClientMessage(playerid, COLOUR_ERRO, "[ERRO] Tipo informar é invalido!");
}
return 1;}

dcmd_setsvfullminutes(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
new string[128];
if(!strlen(params)){
format(string, sizeof(string), "[INFO]: Minutos para o kick automático: %i", SvFullValueMinutes);
SendClientMessage(playerid, COLOUR_CINZA,string);
SendClientMessage(playerid, COLOUR_ERRO,"[INFO]: Para alterar: /setsvfullminutes <MINUTOS>");
return 1;}
if(!IsNumeric(params)) return SendClientMessage(playerid,COLOUR_ERRO,"ERRO: Minutos inválidos");
new param=strval(params);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"SETSVFULLMINUTES");
SvFullValueMinutes = param;
dini_IntSet("ZNS.ini","SvFullValueMinutes", SvFullValueMinutes);
format(string, sizeof(string), "[INFO]: Minutos para o kick automático: %i", SvFullValueMinutes);
SendClientMessage(playerid, COLOUR_INFORMACAO, string);
return 1;}

dcmd_bugar(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!strlen(params)) return SendClientMessage(playerid, COLOUR_ERRO,"USO: /bugar <ID>");
if(!IsNumeric(params)) return SendClientMessage(playerid,COLOUR_ERRO,"ERRO: ID Invalida");
new param=strval(params);
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) if(CallRemoteFunction("GetPlayerAdminLevel","i",param) > 1) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não pode bugar um administrador!");
if(!IsPlayerConnected(param)) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[10]);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"BUGAR");
new string[140], pname[MAX_PLAYER_NAME];
GetPlayerName(param, pname, sizeof(pname));
if(Bugar[param] == false){
format(string, sizeof(string), "[INFO]: %s (%i): não replicará seus movimentos aos outros players!", pname, playerid, params);
Bugar[param] = true;
}else{
format(string, sizeof(string), "[INFO]: %s (%i): voltou a ser sincronizado no servidor!", pname, playerid, params);
Bugar[param] = false;}
SendClientMessage(playerid, COLOUR_INFORMACAO, string);
return 1;}

dcmd_aban(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!strlen(params)){
SendClientMessage(playerid, COLOUR_ERRO,"USO: /aban <id> <motivo> - {FFFFFF}Sistema de banimento de alto nível para adms fakes");
return 1;}
new tmp[128], Index, player;
tmp = strtok(params,Index); //Parametro 1 String
player = strval(tmp); //Parametro 1 Int
new PosString = strlen(tmp) + 1; //Parametro 2 String
if(!IsNumeric(tmp)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: ID Inválida");
if(!IsPlayerConnected(player)) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[10]);
if(CallRemoteFunction("GetPlayerAdminLevel","i",player) > 0) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não pode banir um administrador");
if(!strlen(params[PosString])) return SendClientMessage(playerid, COLOUR_ERRO,"[ERRO]: Motivo não definido");
new string[140], string2[140], pname[MAX_PLAYER_NAME], pname2[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, sizeof(pname));
GetPlayerName(player, pname2, sizeof(pname));
format(string, sizeof(string), "Administrador: %s - Motivo: %s", ABanNick, params[PosString]);
format(string2, sizeof(string2), "[ADM]: %s (%i) baniu %s (%i): {C1C1C1}%s", pname, playerid, pname2, player, params[PosString]);
CallRemoteFunction("SaveToFile","ss","BanidosABAN",string2);
CallRemoteFunction("MessageToAdmins","is",COLOUR_AVISO,string2);
CallRemoteFunction("BanirPlayerEx","is",player,string);
SendClientMessage(playerid, COLOUR_AVISO, "[AVISO]: Este tipo de banimento não mostra a informação de revisão");
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Seu banimento foi aplicado e por segurança seu nick foi logado");
return 1;}

dcmd_akick(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!strlen(params)){
SendClientMessage(playerid, COLOUR_ERRO,"USO: /akick <id> <motivo> - {FFFFFF}Sistema de kickamento de alto nível para adms fakes");
return 1;}
new tmp[128], Index, player;
tmp = strtok(params,Index); //Parametro 1 String
player = strval(tmp); //Parametro 1 Int
new PosString = strlen(tmp) + 1; //Parametro 2 String
if(!IsNumeric(tmp)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: ID Inválida");
if(!IsPlayerConnected(player)) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[10]);
//if(CallRemoteFunction("GetPlayerAdminLevel","i",player) > 0) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não pode kickar um administrador");
if(!strlen(params[PosString])) return SendClientMessage(playerid, COLOUR_ERRO,"[ERRO]: Motivo não definido");
new string[140], string2[140], pname[MAX_PLAYER_NAME], pname2[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, sizeof(pname));
GetPlayerName(player, pname2, sizeof(pname));
format(string, sizeof(string), "Administrador: %s - Motivo: %s", ABanNick, params[PosString]);
format(string2, sizeof(string2), "[ADM]: %s (%i) kickou %s (%i): {C1C1C1}%s", pname, playerid, pname2, player, params[PosString]);
CallRemoteFunction("SaveToFile","ss","KickadosAKICK",string2);
CallRemoteFunction("MessageToAdmins","is",COLOUR_AVISO,string2);
CallRemoteFunction("KickPlayerEx","is",player,string);
SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: Seu kick foi aplicado e por segurança seu nick foi logado");
return 1;}

dcmd_abann(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
new string[140];
if(!strlen(params)){
format(string, sizeof(string), "Uso: /abann <nick> {FFFFFF}Troca o nick do ADM do /aban - Nick atual: %s", ABanNick);
SendClientMessage(playerid, COLOUR_ERRO,string);
return 1;}
if(strlen(params) < 3) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Nick pequeno demais!");
if(strlen(params) > 20) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Nick longo demais!");
format(ABanNick, sizeof(ABanNick), "%s", params);
format(string, sizeof(string), "[INFO]: Novo nick do /ABAN: {C1C1C1}%s", params);
dini_Set("ZNS.ini","abannick",params);
SendClientMessage(playerid, COLOUR_INFORMACAO, string);
return 1;}

dcmd_pmadm(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!strlen(params)) return SendClientMessage(playerid, COLOUR_ERRO,"Uso: /pmadm <id> <mensagem>");
new tmp[128], Index, player;
tmp = strtok(params,Index); //Parametro 1 String
player = strval(tmp); //Parametro 1 Int
new PosString = strlen(tmp) + 1; //Parametro 2 String
if(!IsNumeric(tmp)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: ID Inválida");
if(!IsPlayerConnected(player)) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[10]);
if(!strlen(params[PosString])) return SendClientMessage(playerid, COLOUR_ERRO,"[ERRO]: Mensagem não definida");
new string[140], string2[140], pname[MAX_PLAYER_NAME], pname2[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, sizeof(pname));
GetPlayerName(player, pname2, sizeof(pname));
format(string, sizeof(string), "** PM da Administração: %s", params[PosString]);
format(string2, sizeof(string2), "[ADM]: %s (%i) a %s (%i): {C1C1C1}%s", pname, playerid, pname2, player, params[PosString]);
PlayerPlaySound(player,1057,0.0,0.0,0.0);
SendClientMessage(player, COLOUR_AVISO, string);
GameTextForPlayer(player,"~n~~n~~n~~n~~n~~n~~n~~y~PM RECEBIDA!", 3000, 5);
CallRemoteFunction("MessageToAdmins","is",COLOUR_AVISO,string2);
return 1;}

dcmd_gps(playerid,params[]){
	new Rastreado;
	if(!strlen(params)) return SendClientMessage(playerid, COLOUR_ERRO, "USO: /GPS [playerid/nick] | off");
	if(!IsNumeric(params)){
	if(!strcmp(params,"off",true)){
	if(GPS_Ativo[playerid] == false) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O GPS ja esta desligado");
	PararGPS(playerid);
	SendClientMessage(playerid, COLOUR_INFORMACAO, "[INFO]: O Sistema de GPS foi desligado");return 1;}
	Rastreado = ReturnPlayerID(params);}else{Rastreado = strval(params);}
	if(playerid == Rastreado) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não pode ligar o GPS em você mesmo");
	if(!IsPlayerConnected(Rastreado)) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O player não esta online");
	if(GPS_Ativo[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: O GPS ja esta ligado. Digite /GPS OFF para desligar");
	IniciarGPS(playerid,Rastreado);
	new String[128];
	new Gname[MAX_PLAYER_NAME]; GetPlayerName(Rastreado, Gname, sizeof(Gname));
	PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	format(String, sizeof(String), "[INFO]: Sistema de GPS ligado no player %s (%d).", Gname, Rastreado);
	SendClientMessage(playerid, COLOUR_INFORMACAO, String);
	return 1;
}


dcmd_tela3(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!strlen(params)){
SendClientMessage(playerid, COLOUR_INFORMACAO,"[INFO]: Exibindo padrões para o /TELA3");
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) >= 2) SendClientMessage(playerid, COLOUR_ERRO,"[USO]: /tela3 <segundos> <mensagem>");
ShowTela3ForPlayer(playerid);
return 1;}
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(StringTXTBugado(params)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Seu texto está com erros e foi bloqueado para evitar crash's");
new tmp[128], Index, segundos;
tmp = strtok(params,Index); //Parametro 1 String
segundos = strval(tmp); //Parametro 1 Int
new PosString = strlen(tmp) + 1; //Parametro 2 String
if(!IsNumeric(tmp)){
segundos = 10;
PosString = 0;}
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5 && segundos > 30) return SendClientMessage(playerid, COLOUR_ERRO,"[ERRO]: Em segundos use de 1 até 30");
if(segundos < 1) return SendClientMessage(playerid, COLOUR_ERRO,"[ERRO]: Em segundos use de 1 até 30");
if(!strlen(params[PosString])) return SendClientMessage(playerid, COLOUR_ERRO,"[ERRO]: Mensagem não definida");
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"TELA3");
Tela3Set(segundos,params[PosString],1);
if(PosString == 0) SendClientMessage(playerid,COLOUR_AVISO,"[AVISO]: Segundos não foram digitados! Exibindo com a duração padrão de 10 segundos...");
return 1;}



stock IsADS(text[])
{
new st;
if(strfind(text, "www.", false) != -1) st = 1;
if(strfind(text, "www", false) != -1) st = 1;
if(strfind(text, "www .", false) != -1) st = 1;
if(strfind(text, ".com", false) != -1) st = 1;
if(strfind(text, ". com", false) != -1) st = 1;
if(strfind(text, "blogspot", false) != -1) st = 1;
if(strfind(text, "youtube", false) != -1) st = 1;
if(strfind(text, "no-ip", false) != -1) st = 1;
if(strfind(text, "http://", false) != -1) st = 1;
return st;
}

dcmd_placa(playerid,params[]){
//if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!strlen(params)){
if(UsandoTXTPlaca[playerid] == true){
Delete3DTextLabel(TXTPlaca[playerid]);
UsandoTXTPlaca[playerid] = false;
SendClientMessage(playerid, COLOUR_AVISO,"[INFO]: Placa local removida!");
return 1;
}else{
SendClientMessage(playerid, COLOUR_ERRO,"Uso: /placa <texto>");
return 1;}}
//CallRemoteFunction("CMDMessageToAdmins","is",playerid,"PLACA");
new string[170];
new pname[MAX_PLAYER_NAME];
if(strlen(params) > 120) return SendClientMessage(playerid, COLOUR_ERRO,"[ERRO]: Texto muito grande! Use no máximo 120 caracteres.");
if(FindIpPattern(playerid,params)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Texto inválido");
if(IsADS(params)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Texto inválido");
if(CallRemoteFunction("GetPlayerCash", "i", playerid) < 10000) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não possui dinheiro o suficiente. Necessário: $10000");
CallRemoteFunction("GivePlayerCash", "ii", playerid, -10000);
if(UsandoTXTPlaca[playerid] == true){
Delete3DTextLabel(TXTPlaca[playerid]);
UsandoTXTPlaca[playerid] = false;}
GetPlayerName(playerid, pname, sizeof(pname));
format(string, sizeof(string), "{FFFFFF}%s\n\n{A5A5A5}%s (%i)", params,pname,playerid);
new Float:playerposx, Float:playerposy, Float:playerposz;
GetPlayerPos(playerid, playerposx, playerposy, playerposz);
new StrAviso[100];
format(StrAviso, sizeof(StrAviso), "[ADM]: %s (%i) fez uma placa: %s", pname, playerid, params);
CallRemoteFunction("MessageToAdmins","is",COLOUR_AVISO,StrAviso);
UsandoTXTPlaca[playerid] = true;
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2)
TXTPlaca[playerid] = Create3DTextLabel("Criando placa...",0xFFFFFFFF,playerposx,playerposy,playerposz,35,0,0);
else
TXTPlaca[playerid] = Create3DTextLabel("Criando placa...",0xFFFFFFFF,playerposx,playerposy,playerposz,100,0,0);
Update3DTextLabelText(TXTPlaca[playerid], 0xFFFFFFFF, string);
SendClientMessage(playerid, COLOUR_INFORMACAO,"* Placa definida! Ela permanecerá até você sair do servidor ou digitar /placa");
SendClientMessage(playerid, COLOUR_INFORMACAO,"* Cada marcação de placa custa $10000");
return 1;}

dcmd_notificar(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!strlen(params)){CallRemoteFunction("Notificar","s","   "); return 1;}
if(StringTXTBugado(params)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Seu texto está com erros e foi bloqueado para evitar crash's");
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"NOTIFICAR");
CallRemoteFunction("Notificar","s",params);
return 1;}

dcmd_inativo(playerid,params[]){
//if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 1) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!strlen(params)) return SendClientMessage(playerid, COLOUR_ERRO,"USO: /inativo <ID>");
if(!IsNumeric(params)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: ID Invalida");
new param=strval(params);
if(!IsPlayerConnected(param)) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[10]);
new pname[MAX_PLAYER_NAME];
GetPlayerName(param, pname, sizeof(pname));
new string[128];

	if(AwaySeconds[param] < 1)
	{
	format(string, sizeof(string), "[INFO]: %s (%i) não esta inativo", pname,param,AwaySeconds[param]);
	SendClientMessage(playerid, COLOUR_INFORMACAO, string);
	return 1;
	}

	if(AwaySeconds[param] > 0)
	format(string, sizeof(string), "[INFO]: %s (%i) inativo há: {C0C0C0}%i segundo (s)", pname,param,AwaySeconds[param]);

	if(AwaySeconds[param] > 59)
	format(string, sizeof(string), "[INFO]: %s (%i) inativo há: {C0C0C0}%i minuto (s)", pname,param,AwaySeconds[param]/60);

	if(AwaySeconds[param] > 3559)
	format(string, sizeof(string), "[INFO]: %s (%i) inativo há mais de: {C0C0C0}%i hora (s) [%i minutos]", pname,param,AwaySeconds[param]/3600,AwaySeconds[param]/60);

SendClientMessage(playerid, COLOUR_INFORMACAO, string);
return 1;}

dcmd_granafacil(playerid,params[]){
if(!strlen(params)) return ShowGranaFacilLucros(playerid);
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!IsNumeric(params)) return SendClientMessage(playerid,COLOUR_ERRO,"ERRO: Quantia Invalida");
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"GRANAFACIL");
new param=strval(params);
new string[128];
format(string, sizeof(string), "[INFO]: Grana fácil do servidor definida para: {C0C0C0}$%i", param);
SetGranaFacil(param);
SendClientMessage(playerid, COLOUR_INFORMACAO, string);
ShowGranaFacilLucros(playerid);
return 1;}

dcmd_rmwanted(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 3) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!strlen(params)) return SendClientMessage(playerid, COLOUR_ERRO,"USO: /rmwanted <ID>");
if(!IsNumeric(params)) return SendClientMessage(playerid,COLOUR_ERRO,"ERRO: ID Invalida");
new param=strval(params);
if(!IsPlayerConnected(param)) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[10]);
if(CallRemoteFunction("GetPlayerAdminLevel","i",param) > 0) return SendClientMessage(playerid,COLOUR_ERRO,"ERRO: Jogador é ADMIN");
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"RMWANTED");
new sss[128];new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, sizeof(pname));
format(sss, sizeof(sss), "Administrador %s retirou sua recompensa", pname);
SendClientMessage(param, COLOUR_ERRO,sss);
SendClientMessage(playerid, COLOUR_INFORMACAO,"A recompensa e KillSpree do jogador foi removida.");
Spree[param] = 0;
SetPlayerWantedLevel(param, 0);
return 1;}

dcmd_velocidade(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!strlen(params)) return SendClientMessage(playerid, COLOUR_ERRO,"USO: /velocidade <ID>");
if(!IsNumeric(params)) return SendClientMessage(playerid,COLOUR_ERRO,"ERRO: ID Invalida");
new param=strval(params);
if(!IsPlayerConnected(param)) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[10]);
new sss[128];new pname[MAX_PLAYER_NAME];
GetPlayerName(param, pname, sizeof(pname));
format(sss, sizeof(sss), "Velocidade de %s: %i KM/h", pname,GetPlayerSpeed(param,true));
SendClientMessage(playerid, COLOUR_INFORMACAO,sss);
return 1;}

dcmd_kcor(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!strlen(params)) return SendClientMessage(playerid, COLOUR_ERRO,"USO: /kcor <ID>");
if(!IsNumeric(params)) return SendClientMessage(playerid,COLOUR_ERRO,"ERRO: ID Invalida");
new param=strval(params);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"KCOR");
if(!IsPlayerConnected(param)) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[10]);
cor[param] = 0;
new admname[MAX_PLAYER_NAME],strr[100];
GetPlayerName(playerid, admname, sizeof(admname));
format(strr, sizeof(strr), "Por %s - Devido a estar usando cor muito escura", admname);
CallRemoteFunction("KickPlayerEx","is",param,strr);
return 1;}

dcmd_kmae(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!strlen(params)) return SendClientMessage(playerid, COLOUR_ERRO,"USO: /kmae <ID>");
if(!IsNumeric(params)) return SendClientMessage(playerid,COLOUR_ERRO,"ERRO: ID Invalida");
new param=strval(params);
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"KMAE");
if(!IsPlayerConnected(param)) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[10]);
new admname[MAX_PLAYER_NAME],strr[100];
GetPlayerName(playerid, admname, sizeof(admname));
format(strr, sizeof(strr), "Por %s - Ofensas a parentesco", admname);
CallRemoteFunction("KickPlayerEx","is",param,strr);
return 1;}

dcmd_id(playerid,params[]){
if(!strlen(params)) return SendClientMessage(playerid,COLOUR_ERRO,"[USO]: /id <nick / parte do nick>");
PesquisarIDDialog(playerid,params);
return 1;}

dcmd_fip(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 2) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[8]);
if(!strlen(params)) return SendClientMessage(playerid,COLOUR_ERRO,"[USO]: /fip <IP / parte do IP>");
PesquisarIPDialog(playerid,params);
return 1;}

dcmd_svname(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 6) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!strlen(params))
{CallRemoteFunction("CMDMessageToAdmins","is",playerid,"SVNAME");new string[60];
format(string, sizeof(string), "hostname %s", DefaultHostname);
dini_Set("ZNS.ini","svname",DefaultHostname);
SendRconCommand(string);
return 1;}
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"SVNAME");new string[60];
format(string, sizeof(string), "hostname %s", params);
dini_Set("ZNS.ini","svname",params);
SendRconCommand(string);
return 1;}

forward countdown();
public countdown(){
if(Locality == 0){
switch(CountStage){case 1:{
GameTextForAll("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~-~y~]~g~-~g~GO~g~-~y~]~g~-",1000,3);
for(new i; i < GetMaxPlayers(); i++){
if(Frozen[i] == 1) TogglePlayerControllable(i, 1), Frozen[i] = 0;
else if(Frozen[i] == 2) Frozen[i] = 0;
GetPlayerPos(i,ccX,ccY,ccZ);
PlayerPlaySound(i,1057,ccX,ccY,ccZ);}
KillTimer(timer);
CountStage = 0;}
case 2: GameTextForAll("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~-~y~ 1 ~g~-",1000,3), CountStage = 1;
case 3: GameTextForAll("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~-~y~ 2 ~g~-",1000,3), CountStage = 2;}}
if(Locality == 1){
switch(CountStage){case 1:{
for(new i; i < GetMaxPlayers(); i++){
if(Frozen[i] != 0){
GameTextForPlayer(i, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~-~y~]~g~-~g~GO~g~-~y~]~g~-",1000,3);
if(Frozen[i] == 1) TogglePlayerControllable(i, 1);
Frozen[i] = 0;
GetPlayerPos(i,ccX,ccY,ccZ);
PlayerPlaySound(i,1057,ccX,ccY,ccZ);}}
KillTimer(timer);
CountStage = 0;}
case 2:{
for(new i; i < GetMaxPlayers(); i++){
if(Frozen[i] != 0) GameTextForPlayer(i, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~-~y~ 1 ~g~-",1000,3);}
CountStage = 1;}
case 3:{
for(new i; i < GetMaxPlayers(); i++){
if(Frozen[i] != 0)      GameTextForPlayer(i, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~-~y~ 2 ~g~-",1000,3);}
CountStage = 2;}}}}

stock PesquisarIDRCON(pesquisa[])
{

	if(strlen(pesquisa) < 3) return print("[ERRO]: Palavra chave muito pequena, tente com pelo menos 3 caracteres");
	new found, results[100],playername[MAX_PLAYER_NAME];
	for(new i; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i))
		{
	  		GetPlayerName(i, playername, MAX_PLAYER_NAME);
			new namelen = strlen(playername);
			new bool:searched=false;
	    	for(new pos=0; pos <= namelen; pos++)
			{
				if(searched != true)
				{
					if(strfind(playername,pesquisa,true) == pos)
					{
		                found++;
		                if(found < 20) format(results,sizeof(results),"%dº - %s (%d)",found,playername,i);
                  		print(results);
						searched = true;
					}
				}
			}
		}
	}

	new DialogString[100];
	if(found > 0)
	format(DialogString,sizeof(DialogString),"Você pesquisou: %s - Resultados: %i",pesquisa,found);
	else
	format(DialogString,sizeof(DialogString),"Sua pesquisa por \"%s\" nao teve resultados",pesquisa);
	print(DialogString);
	return 1;
}

stock PesquisarIDDialog(playerid,pesquisa[])
{

	if(strlen(pesquisa) < 3) return ShowPlayerDialog(playerid,5501,DIALOG_STYLE_MSGBOX,"Pesquisa de nicks","{FF0000}ERRO:{FFFFFF} Palavra muito pequena\n\n{00FF00}A pesquisa deve ter no mínimo 3 caracteres","OK","Voltar");
	new found, results[800],playername[MAX_PLAYER_NAME];
	for(new i; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i))
		{
	  		GetPlayerName(i, playername, MAX_PLAYER_NAME);
			new namelen = strlen(playername);
			new bool:searched=false;
	    	for(new pos=0; pos <= namelen; pos++)
			{
				if(searched != true)
				{
					if(strfind(playername,pesquisa,true) == pos)
					{
		                found++;
		                if(found < 20) format(results,sizeof(results),"%s\n%dº - %s (%d)",results,found,playername,i);
						searched = true;
					}
				}
			}
		}
	}

	new DialogString[900];
	if(found > 0)
	format(DialogString,sizeof(DialogString),"{FFFFFF}Você pesquisou: {00FF00}%s{FFFFFF} - Resultados: {00FF00}%i{09D19B}\n%s\n",pesquisa,found,results);
	else
	format(DialogString,sizeof(DialogString),"{FFFFFF}Sua pesquisa por {FFFF00}\"%s\"{FFFFFF} não teve resultados\n",pesquisa);
	ShowPlayerDialog(playerid,5501,DIALOG_STYLE_MSGBOX,"Pesquisa de nicks",DialogString,"OK","Voltar");
	return 1;
}

stock PesquisarIPRCON(pesquisa[])
{

	if(strlen(pesquisa) < 3) return print("[ERRO]: Pesquisa muito pequena! Tente pelo menos com 3 caracteres.");
	new found, result[100],playerip[16];
	for(new i; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i))
		{
	  		GetPlayerIp(i, playerip, sizeof(playerip));
			new iplen = strlen(playerip);
			new bool:searched=false;
	    	for(new pos=0; pos <= iplen; pos++)
			{
				if(searched != true)
				{
					if(strfind(playerip,pesquisa,true) == pos)
					{
						new pname[MAX_PLAYER_NAME];
						GetPlayerName(i, pname, MAX_PLAYER_NAME);
		                found++;
		                if(found < 20) format(result,sizeof(result),"%dº - %s - %s (%d)",found,playerip,pname,i);
		                print(result);
						searched = true;
					}
				}
			}
		}
	}

	new DialogString[900];
	if(found > 0)
	format(DialogString,sizeof(DialogString),"Você pesquisou: %s - Resultados: %i",pesquisa,found);
	else
	format(DialogString,sizeof(DialogString),"Sua pesquisa por \"%s\" nao teve resultados\n",pesquisa);
	print(DialogString);
	return 1;
}


stock PesquisarIPDialog(playerid,pesquisa[])
{

	if(strlen(pesquisa) < 3) return ShowPlayerDialog(playerid,5501,DIALOG_STYLE_MSGBOX,"Pesquisa de nicks","{FF0000}ERRO:{FFFFFF} Palavra muito pequena\n\n{00FF00}A pesquisa deve ter no mínimo 3 caracteres","OK","Voltar");
	new found, results[800],playerip[16];
	for(new i; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i))
		{
	  		GetPlayerIp(i, playerip, sizeof(playerip));
			new iplen = strlen(playerip);
			new bool:searched=false;
	    	for(new pos=0; pos <= iplen; pos++)
			{
				if(searched != true)
				{
					if(strfind(playerip,pesquisa,true) == pos)
					{
						new pname[MAX_PLAYER_NAME];
						GetPlayerName(i, pname, MAX_PLAYER_NAME);
		                found++;
		                if(found < 20) format(results,sizeof(results),"%s\n%dº - %s - %s (%d)",results,found,playerip,pname,i);
						searched = true;
					}
				}
			}
		}
	}

	new DialogString[900];
	if(found > 0)
	format(DialogString,sizeof(DialogString),"{FFFFFF}Você pesquisou: {00FF00}%s{FFFFFF} - Resultados: {00FF00}%i{09D19B}\n%s\n",pesquisa,found,results);
	else
	format(DialogString,sizeof(DialogString),"{FFFFFF}Sua pesquisa por {FFFF00}\"%s\"{FFFFFF} não teve resultados\n",pesquisa);
	ShowPlayerDialog(playerid,5501,DIALOG_STYLE_MSGBOX,"Pesquisa de IP's",DialogString,"OK","Voltar");
	return 1;
}


stock Tela3Set(miliseconds,text[],priority = 1)
{
if(Tela3Displaying == true && priority == 0) return 1;
if(Tela3Displaying) KillTimer(TimerTELA3);
new string[128];
format(string, sizeof(string), "%s", text);
Tela3Displaying = true;
TextDrawSetString((TxDTela3),string);
TextDrawShowForAll(TxDTela3);
TimerTELA3 = SetTimer("LimparTela3",miliseconds*1000,0);
return 1;
}

stock Distance(Float:a, Float:b, Float:c, Float:d, Float:e, Float:f)
{
        dist = floatsqroot(floatpower((a - d),2)+floatpower((b - e),2)+floatpower((c - f),2));
    return floatround(dist);
}

stock IsNumeric(string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
		if (string[i] > '9' || string[i] < '0') return 0;
	}
	return 1;
}

stock DesativarUltraGC()
{

}


stock ToggleAllControllable(onoff)
{
    for(new i; i < GetMaxPlayers(); i++)
                {
                if(Freeze == 1 && onoff == 0) Frozen[i] = 1;
                else if(Freeze == 0 && onoff == 0) Frozen[i] = 2;
                else if(onoff == 1) Frozen[i] = 0;
                TogglePlayerControllable(i,onoff);
                }
}

forward GetVehicleDriver(vehicleid);
public GetVehicleDriver(vehicleid)
{
    for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i))
    {
        if (IsPlayerInVehicle(i, vehicleid))
        {
            if(GetPlayerState(i) == 2)
            {
       		return i;
            }
	}
    }}
    return -1;
}

stock ChatProximo(playerid, color, const string[])
{
        new output[128], pNameX[MAX_PLAYER_NAME],outadm[128],rawstring[128];
        GetPlayerName(playerid, pNameX, sizeof(pNameX));

        format(output, sizeof(output), "%s: (%i): %s", pNameX, playerid, string);
        format(rawstring, sizeof(rawstring), "%s",string);

        new Float:PosX, Float:PosY, Float:PosZ;
        GetPlayerPos(playerid, PosX, PosY, PosZ);

        format(outadm, sizeof(outadm), "CHATP >> %s: (%i): %s", pNameX,playerid,string);
        for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){
		if(CallRemoteFunction("GetPlayerAdminLevel","i",i) >= 4){
		if(!IsPlayerInRangeOfPoint(i, 20.0, PosX, PosY, PosZ)){
		SendClientMessage(i, 0xFF9900AA, outadm);}}}}

        for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){
        if(IsPlayerInRangeOfPoint(i, 20.0, PosX, PosY, PosZ)){
		SendClientMessage(i, color, output);
		PlayerPlaySound(i,1057,0.0,0.0,0.0);}}}
		SetPlayerChatBubble(playerid, rawstring, COLOUR_CHATPROX, 20.0, 10000);

        return 1;
}


stock DesativarUGC()
{
UltraGCAtivoParaTodos = 0;
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){
if(UltraGC[i] == 1){UltraGC[i] = 0;
if(GetPlayerState(i) == PLAYER_STATE_DRIVER){SetVehicleHealth(GetPlayerVehicleID(i),1000.0);}
SetPlayerHealth(i,Float:UltraGC_VIDA[i]);
SetPlayerArmour(i,Float:UltraGC_COLETE[i]);}}}
}

stock AtivarUGC()
{
UltraGCAtivoParaTodos = 1;
}

stock AntiDBBike(playerid)
{
new Float:playerposx, Float:playerposy, Float:playerposz;
GetPlayerPos(playerid, playerposx, playerposy, playerposz);
SetPlayerPos(playerid,playerposx, playerposy, playerposz+2);
RemovePlayerFromVehicle(playerid);
SendClientMessage(playerid, COLOUR_ERRO,"[AVISO]: Atirar p/ fora do veículo não é permitido neste servidor ( /regras )");
return 1;
}

stock AntiDBCar(playerid){
new modelo = GetVehicleModel(GetPlayerVehicleID(playerid));
if(modelo == 520 || modelo == 548 || modelo == 425 || modelo == 417 ||
modelo == 487 || modelo == 488 || modelo == 497 ||
modelo == 563 || modelo == 469 || modelo == 476 || modelo == 447)return 1;
new Float:playerposx, Float:playerposy, Float:playerposz;
GetPlayerPos(playerid, playerposx, playerposy, playerposz);
SetPlayerPos(playerid,playerposx, playerposy, playerposz+2);
RemovePlayerFromVehicle(playerid);
SendClientMessage(playerid, COLOUR_ERRO,"[AVISO]: Atirar p/ fora do veículo não é permitido neste servidor ( /regras )");
return 1;}

forward RemoverTodosAttachsObj(playerid);
public RemoverTodosAttachsObj(playerid)
{
for(new i,a = 5;i < a;i++){
if(IsPlayerAttachedObjectSlotUsed(playerid, i)){
RemovePlayerAttachedObject(playerid,i);}
}
}

forward AAD_CancelaLobby(adminid);
public AAD_CancelaLobby(adminid){
if(AAD_Lobby == 0) return SendClientMessage(adminid, COLOUR_ERRO,"[ERRO]: O A/D não pode ser cancelado a este ponto");
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){if(AAD_Vai[i] == 1){AAD_Vai[i] = 0;}}}
new string[128],pname[MAX_PLAYER_NAME];
GetPlayerName(adminid, pname, sizeof(pname));
format(string, sizeof(string), "Combate A/D: [%s] foi cancelado pelo administrador %s",AAD_Tipo_STR,pname);
SendClientMessageToAll(COLOUR_EVENTOCANCELADO, string);
AAD_Lobby = 0;
AAD_EmProgresso = 0;
KillTimer(AAD_Timer);
AAD_Timer = SetTimer("AAD_DefLobby",AAD_TIME_IntervaloEntrePartidas, 0);
return 1;}

forward PVC_FinalizaLobby(adminid);
public PVC_FinalizaLobby(adminid){
for(new i; i < GetMaxPlayers(); i++){
	if(IsPlayerConnected(i)){
		if(PVC_Vai[i] == 1){
			PVC_Vai[i] = 0;
			SpawnPlayer(i);
		}
	}
}
for(new x; x<51; x++){
	DestroyObject(PVC_Objetos[x]);
}
	DestroyPickup(PVC1);
	DestroyPickup(PVC2);
	DestroyPickup(PVC3);
	DestroyPickup(PVC4);
	DestroyPickup(PVC5);
	DestroyPickup(PVC6);

new string[128],pname[MAX_PLAYER_NAME];
GetPlayerName(adminid, pname, sizeof(pname));
format(string, sizeof(string), "Combate PVC: [%s] foi cancelado pelo administrador %s",PVC_Tipo_STR,pname);
SendClientMessageToAll(COLOUR_EVENTOCANCELADO, string);
PVC_Lobby = 0;
PVC_EmProgresso = 0;
PVC_Moto = false;
PVC_Carro = false;
PVC_Escolher = false;
PVC_Tipo = 0;
KillTimer(PVC_Timer);
PVC_Timer = SetTimer("PVC_DefLobby",PVC_TIME_IntervaloEntrePartidas, 0);
return 1;}

forward PL_FinalizaLobby(adminid);
public PL_FinalizaLobby(adminid){
for(new i; i < GetMaxPlayers(); i++){
	if(IsPlayerConnected(i)){
		if(PL_Vai[i] == 1){
			PL_Vai[i] = 0;
		}
		SpawnPlayer(i);
	}
}
new string[128],pname[MAX_PLAYER_NAME];
GetPlayerName(adminid, pname, sizeof(pname));
format(string, sizeof(string), "[PL]: POLICIA X LADRAO: foi cancelado pelo administrador %s",pname);
SendClientMessageToAll(COLOUR_EVENTOCANCELADO, string);
PL_Lobby = 0;
PL_EmProgresso = 0;
KillTimer(PL_Timer);
PL_Timer = SetTimer("PL_DefLobby",PL_TIME_IntervaloEntrePartidas, 0);
return 1;}

forward AAD_DefIniciar();
public AAD_DefIniciar(){
AAD_Dominado = 0;
AAD_Kills_1 = 0;
AAD_Kills_2 = 0;
AAD_Participantes = 0;
AAD_Balancer = 0;
AAD_Lobby = 0;
AAD_EmProgresso = 1;
for(new i; i < GetMaxPlayers(); i++){
if(IsPlayerConnected(i)) {if(IsPlayerSpawned(i)){
if(AAD_Vai[i] == 1 && Arena[i] == 1) {AAD_Vai[i] = 0;}
if(AAD_Vai[i] == 1){
AAD_OldPlayerColor[i] = GetPlayerColor(i);
AAD_Participantes++;
if(AAD_Balancer == 0){
AAD_Balancer = 1;
AAD_Team[i] = 1;
}else{
AAD_Balancer = 0;
AAD_Team[i] = 2;}}}}}
if(AAD_Participantes > 1){
new string[128];
format(string, sizeof(string), "Combate A/D: [%s] iniciou com %i participantes!",AAD_Tipo_STR,AAD_Participantes);
SendClientMessageToAll(COLOUR_EVENTO, string);
}else{
new string[128];
format(string, sizeof(string), "Combate A/D: [%s] foi cancelado porque ninguem foi",AAD_Tipo_STR);
SendClientMessageToAll(COLOUR_EVENTOCANCELADO, string);
AAD_Lobby = 0;
AAD_EmProgresso = 0;
for(new i; i < GetMaxPlayers(); i++){
if(IsPlayerConnected(i)){
AAD_Vai[i] = 0;
AAD_Team[i] = 0;}}
AAD_Timer = SetTimer("AAD_DefLobby",AAD_TIME_IntervaloEntrePartidas, 0);
return 1;}
for(new i; i < GetMaxPlayers(); i++){
if(IsPlayerConnected(i)) {
if(AAD_Vai[i] == 1 && Arena[i] == 0) {
if(AAD_Team[i] == 1 && AAD_EmProgresso == 1 && AAD_Vai[i] == 1){AAD_SpawnPlayer_1(i);AAD_KillsPerPlayer[i] = 0;}
if(AAD_Team[i] == 2 && AAD_EmProgresso == 1 && AAD_Vai[i] == 1){AAD_SpawnPlayer_2(i);AAD_KillsPerPlayer[i] = 0;}
SetPlayerCheckpoint(i, AAD_CASA_SPAWNS[0][0], AAD_CASA_SPAWNS[0][1], AAD_CASA_SPAWNS[0][2], 3.0);}}}
AAD_Timer = SetTimer("AAD_DefFinalizar",AAD_TIME_DuracaoDaPartida, 0);
return 1;}

forward EAM_DefIniciar();
public EAM_DefIniciar(){
	EAM_EmProgresso = 1;
	EAM_Escolher = false;
	EAM_PlayerMorto = false;
	EAM_QuantPlayer = false;

	for(new i; i < GetMaxPlayers(); i++){
		if(IsPlayerConnected(i)){
			EAM_Player[i] = false;
			EAM_Checkpoint[i] = false;
			EventoProibirTeleEAM[i] = false;
  		}
	}

	new rand = random(sizeof(CheckpointEAM));
	new string[300];
	format(string, sizeof(string), "[EAM]: (%s) esta ativo! Chegue ao checkpoint em primeiro!",EAM_Tipo_STR);
	SendClientMessageToAll(COLOUR_INFORMACAO, string);
	for(new i; i < GetMaxPlayers(); i++){
	    if(Arena[i] == 0){
			if(IsPlayerConnected(i)){
				SetPlayerCheckpoint(i, CheckpointEAM[rand][0], CheckpointEAM[rand][1], CheckpointEAM[rand][2], 6.0);
			}
 		}
	}
	KillTimer(EAM_Timer);
	EAM_Timer = SetTimer("EAM_DefFinalizar",EAM_TIME_DuracaoDaPartida, 0);
}

forward PVC_CancelaLobby(adminid);
public PVC_CancelaLobby(adminid){
if(PVC_Lobby == 0) return SendClientMessage(adminid, COLOUR_ERRO,"[ERRO]: O PVC não pode ser cancelado a este ponto");
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){if(PVC_Vai[i] == 1){PVC_Vai[i] = 0;}}}
new string[128],pname[MAX_PLAYER_NAME];
GetPlayerName(adminid, pname, sizeof(pname));
format(string, sizeof(string), "Combate PVC: [%s] foi cancelado pelo administrador %s",PVC_Tipo_STR,pname);
SendClientMessageToAll(COLOUR_EVENTOCANCELADO, string);
PVC_Lobby = 0;
PVC_EmProgresso = 0;
PVC_Moto = false;
PVC_Carro = false;
PVC_Escolher = false;
KillTimer(PVC_Timer);
PVC_Timer = SetTimer("PVC_DefLobby",PVC_TIME_IntervaloEntrePartidas, 0);
return 1;}

forward PL_CancelaLobby(adminid);
public PL_CancelaLobby(adminid){
if(PL_Lobby == 0) return SendClientMessage(adminid, COLOUR_ERRO,"[ERRO]: O PL não pode ser cancelado a este ponto");
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){if(PL_Vai[i] == 1){PL_Vai[i] = 0;}}}
new string[128],pname[MAX_PLAYER_NAME];
GetPlayerName(adminid, pname, sizeof(pname));
format(string, sizeof(string), "[PL]: POLICIA X LADRAO: foi cancelado pelo administrador %s",pname);
SendClientMessageToAll(COLOUR_EVENTOCANCELADO, string);
PL_Lobby = 0;
PL_EmProgresso = 0;
KillTimer(PL_Timer);
PL_Timer = SetTimer("PL_DefLobby",PL_TIME_IntervaloEntrePartidas, 0);
return 1;}

forward PVC_DefIniciar();
public PVC_DefIniciar(){
	DestroyPickup(PVC1);
	DestroyPickup(PVC2);
	DestroyPickup(PVC3);
	DestroyPickup(PVC4);
	DestroyPickup(PVC5);
	DestroyPickup(PVC6);

	for(new x=0; x<51; x++){
		DestroyObject(PVC_Objetos[x]);
	}
	
PVC_Kills_1 = 0;
PVC_Kills_2 = 0;
PVC_Morte_1 = 0;
PVC_Morte_2 = 0;
PVC_Participantes = 0;
PVC_Balancer = 0;
PVC_Lobby = 0;
PVC_EmProgresso = 1;
PVC_Round = 1;
for(new i; i < GetMaxPlayers(); i++){
if(IsPlayerConnected(i)) {if(IsPlayerSpawned(i)){
if(PVC_Vai[i] == 1 && Arena[i] == 1) {PVC_Vai[i] = 0;}
if(PVC_Vai[i] == 1){
PVC_OldPlayerColor[i] = GetPlayerColor(i);
PVC_Participantes++;
if(PVC_Balancer == 0){
PVC_Balancer = 1;
PVC_Team[i] = 1;
PVC_TeamBkp[i] = 1;
PVC_Nome_Time = "Time A";
PVC_NomeTime[i] = 1;
PVC_TeamA[i] = true;
PVC_TeamB[i] = false;
}else{
PVC_Balancer = 0;
PVC_Team[i] = 2;
PVC_NomeTime[i] = 2;
PVC_TeamBkp[i] = 2;
PVC_Nome_Time = "Time B";
PVC_TeamA[i] = false;
PVC_TeamB[i] = true;}}}}}
if(PVC_Participantes > 1){
}else{
new string[128];
format(string, sizeof(string), "Combate PVC: [%s] foi cancelado porque ninguem foi.",PVC_Tipo_STR);
SendClientMessageToAll(COLOUR_EVENTOCANCELADO, string);
PVC_Lobby = 0;
PVC_EmProgresso = 0;
PVC_Escolher = false;
for(new i; i < GetMaxPlayers(); i++){
if(IsPlayerConnected(i)){
PVC_Vai[i] = 0;
PVC_Team[i] = 0;
PVC_TeamBkp[i] = 0;}}
PVC_Timer = SetTimer("PVC_DefLobby",PVC_TIME_IntervaloEntrePartidas, 0);
return 1;}
for(new i; i < GetMaxPlayers(); i++){
if(IsPlayerConnected(i)) {
if(PVC_Vai[i] == 1 && Arena[i] == 0) {
if(PVC_Team[i] == 1 && PVC_EmProgresso == 1 && PVC_Vai[i] == 1){PVC_SpawnPlayer_1(i);PVC_KillsPerPlayer[i] = 0;}
if(PVC_Team[i] == 2 && PVC_EmProgresso == 1 && PVC_Vai[i] == 1){PVC_SpawnPlayer_2(i);PVC_KillsPerPlayer[i] = 0;}}}}
PVC_Timer = SetTimer("PVC_RoundTrocar",PVC_TIME_DuracaoDaPartida, 0);

if(PVC_Round == 1 && PVC_EmProgresso == 1){
	new string[128];
	format(string, sizeof(string), "Combate PVC: [RODADA %i] [%s] iniciou com %i participantes!",PVC_Round, PVC_Tipo_STR, PVC_Participantes);
	SendClientMessageToAll(COLOUR_EVENTO, string);
	for(new i; i < GetMaxPlayers(); i++){
		if(IsPlayerConnected(i)) {
			if(IsPlayerSpawned(i)){
				if(PVC_Vai[i] == 1) {
				    TextDrawShowForPlayer(i, Textdraw25);
					TextDrawShowForPlayer(i, Textdraw27);
					ContagemPVC(i);
				}
			}
		}
	}
}

//OBJETOS PARA GTA V BY MOTOXEX
if(PVC_EmProgresso == 1){
	PVC_Objetos[0] = CreateObject(2669, 852.04999, -1409.43665, 40.64270,   0.00000, 0.00000, 180.00000);
	PVC_Objetos[1] = CreateObject(2669, 852.04102, -1413.91577, 40.64270,   0.00000, 0.00000, 180.00000);
	PVC_Objetos[2] = CreateObject(2669, 855.06128, -1413.89917, 40.64270,   0.00000, 0.00000, 180.00000);
	PVC_Objetos[3] = CreateObject(2669, 855.04559, -1409.39807, 40.64270,   0.00000, 0.00000, 180.00000);
	PVC_Objetos[4] = CreateObject(2669, 855.03607, -1404.33618, 40.64270,   0.00000, 0.00000, 180.00000);
	PVC_Objetos[5] = CreateObject(2669, 852.05438, -1404.37024, 40.64270,   0.00000, 0.00000, 180.00000);
	PVC_Objetos[6] = CreateObject(2669, 852.08679, -1399.23010, 40.64270,   0.00000, 0.00000, 180.00000);
	PVC_Objetos[7] = CreateObject(2669, 855.00800, -1399.21423, 40.64270,   0.00000, 0.00000, 180.00000);
	PVC_Objetos[8] = CreateObject(2669, 854.99988, -1394.09265, 40.64270,   0.00000, 0.00000, 180.00000);
	PVC_Objetos[9] = CreateObject(2669, 852.11768, -1394.14954, 40.64270,   0.00000, 0.00000, 180.00000);
	PVC_Objetos[10] = CreateObject(2669, 858.10468, -1413.83655, 40.64270,   0.00000, 0.00000, 180.00000);
	PVC_Objetos[11] = CreateObject(2669, 858.08673, -1409.37671, 40.64270,   0.00000, 0.00000, 180.00000);
	PVC_Objetos[12] = CreateObject(2669, 858.05890, -1404.35559, 40.64270,   0.00000, 0.00000, 180.00000);
	PVC_Objetos[13] = CreateObject(2669, 858.05389, -1399.19397, 40.64270,   0.00000, 0.00000, 180.00000);
	PVC_Objetos[14] = CreateObject(2669, 858.04846, -1394.09265, 40.64270,   0.00000, 0.00000, 180.00000);
	PVC_Objetos[15] = CreateObject(2669, 856.15894, -1387.89575, 40.64270,   0.00000, 0.00000, 270.00000);
	PVC_Objetos[16] = CreateObject(2669, 853.39893, -1387.86682, 40.64270,   0.00000, 0.00000, 270.00000);
	PVC_Objetos[17] = CreateObject(2669, 857.99127, -1389.10278, 40.64270,   0.00000, 0.00000, 180.00000);
	PVC_Objetos[18] = CreateObject(2669, 854.98840, -1389.08521, 40.64270,   0.00000, 0.00000, 180.00000);
	PVC_Objetos[19] = CreateObject(2669, 852.12512, -1389.07397, 40.64270,   0.00000, 0.00000, 180.00000);
	PVC_Objetos[20] = CreateObject(2669, 911.07599, -1407.87854, 11.73660,   -18.00000, 0.00000, -91.00000);
	PVC_Objetos[21] = CreateObject(2669, 906.77362, -1407.80444, 13.19460,   -18.00000, 0.00000, -91.00000);
	PVC_Objetos[22] = CreateObject(2669, 902.30682, -1407.71912, 14.65260,   -18.00000, 0.00000, -91.00000);
	PVC_Objetos[23] = CreateObject(2669, 897.82196, -1407.65466, 16.11060,   -18.00000, 0.00000, -91.00000);
	PVC_Objetos[24] = CreateObject(2669, 892.82257, -1407.55322, 17.73060,   -18.00000, 0.00000, -91.00000);
	PVC_Objetos[25] = CreateObject(2669, 888.49652, -1407.53259, 19.51260,   -28.00000, 0.00000, -91.00000);
	PVC_Objetos[26] = CreateObject(2669, 884.17188, -1407.43494, 22.26660,   -37.00000, 0.00000, -91.00000);
	PVC_Objetos[27] = CreateObject(2669, 880.72986, -1407.36621, 25.34460,   -47.00000, 0.00000, -91.00000);
	PVC_Objetos[28] = CreateObject(2669, 921.25641, -1398.06213, 11.73660,   -18.00000, 0.00000, -91.00000);
	PVC_Objetos[29] = CreateObject(2669, 916.27246, -1397.98621, 13.35660,   -18.00000, 0.00000, -91.00000);
	PVC_Objetos[30] = CreateObject(2669, 911.34344, -1397.89453, 14.97660,   -18.00000, 0.00000, -91.00000);
	PVC_Objetos[31] = CreateObject(2669, 906.29218, -1397.81494, 16.59660,   -18.00000, 0.00000, -91.00000);
	PVC_Objetos[32] = CreateObject(2669, 901.37640, -1397.72595, 18.21660,   -18.00000, 0.00000, -91.00000);
	PVC_Objetos[33] = CreateObject(2669, 896.65204, -1397.64026, 20.48460,   -33.00000, 0.00000, -91.00000);
	PVC_Objetos[34] = CreateObject(2669, 892.62140, -1397.58484, 23.56260,   -43.00000, 0.00000, -91.00000);
	PVC_Objetos[35] = CreateObject(2669, 800.79047, -1397.75415, 11.73660,   -18.00000, 0.00000, 89.00000);
	PVC_Objetos[36] = CreateObject(2669, 808.42767, -1407.96558, 11.73660,   -18.00000, 0.00000, 89.00000);
	PVC_Objetos[37] = CreateObject(2669, 805.76758, -1397.81958, 13.35660,   -18.00000, 0.00000, 89.00000);
	PVC_Objetos[38] = CreateObject(2669, 810.75592, -1397.91272, 14.97660,   -18.00000, 0.00000, 89.00000);
	PVC_Objetos[39] = CreateObject(2669, 815.72137, -1398.04968, 16.59660,   -18.00000, 0.00000, 89.00000);
	PVC_Objetos[40] = CreateObject(2669, 820.69348, -1398.12646, 18.21660,   -18.00000, 0.00000, 89.00000);
	PVC_Objetos[41] = CreateObject(2669, 825.63269, -1398.19727, 19.83660,   -18.00000, 0.00000, 89.00000);
	PVC_Objetos[42] = CreateObject(2669, 830.08466, -1398.27112, 21.78060,   -29.00000, 0.00000, 89.00000);
	PVC_Objetos[43] = CreateObject(2669, 834.14130, -1398.31653, 24.69660,   -42.00000, 0.00000, 89.00000);
	PVC_Objetos[44] = CreateObject(2669, 813.43207, -1408.02637, 13.35660,   -18.00000, 0.00000, 89.00000);
	PVC_Objetos[45] = CreateObject(2669, 818.43646, -1408.08740, 14.97660,   -18.00000, 0.00000, 89.00000);
	PVC_Objetos[46] = CreateObject(2669, 823.46844, -1408.10388, 16.59660,   -18.00000, 0.00000, 89.00000);
	PVC_Objetos[47] = CreateObject(2669, 827.51459, -1408.18005, 18.70260,   -42.00000, 0.00000, 89.00000);
	PVC_Objetos[48] = CreateObject(2669, 831.32788, -1408.29797, 22.10460,   -42.00000, 0.00000, 89.00000);
	PVC_Objetos[49] = CreateObject(2669, 836.72534, -1398.29993, 27.77460,   -51.00000, 0.00000, 89.00000);
	PVC_Objetos[50] = CreateObject(2669, 834.00555, -1408.36072, 25.50660,   -56.00000, 0.00000, 89.00000);
}

	//PICKUPS CARROS VS PLAYERS GTA V BY MOTOXEX
	if(PVC_Tipo == 0 && PVC_EmProgresso == 1 && PVC_EmProgresso == 1){
	 	PVC1 = CreatePickup(359, 2, 855.48468,-1404.04810,42.79400, -1);
		PVC2 = CreatePickup(359, 2, 853.05347,-1413.53149,42.79400, -1);
		PVC3 = CreatePickup(359, 2, 857.85236,-1413.68018,42.79400, -1);
		PVC4 = CreatePickup(359, 2, 855.66589,-1399.49414,42.79400, -1);
		PVC5 = CreatePickup(359, 2, 857.41882,-1389.55115,42.79400, -1);
		PVC6 = CreatePickup(359, 2, 853.15094,-1389.47656,42.79400, -1);
	}else if(PVC_Tipo == 1 && PVC_EmProgresso == 1 && PVC_EmProgresso == 1){
	 	PVC1 = CreatePickup(358, 2, 855.48468,-1404.04810,42.79400, -1);
		PVC2 = CreatePickup(358, 2, 853.05347,-1413.53149,42.79400, -1);
		PVC3 = CreatePickup(358, 2, 857.85236,-1413.68018,42.79400, -1);
		PVC4 = CreatePickup(358, 2, 855.66589,-1399.49414,42.79400, -1);
		PVC5 = CreatePickup(358, 2, 857.41882,-1389.55115,42.79400, -1);
		PVC6 = CreatePickup(358, 2, 853.15094,-1389.47656,42.79400, -1);
	}else if(PVC_Tipo == 2 && PVC_EmProgresso == 1 && PVC_EmProgresso == 1){
	 	PVC1 = CreatePickup(359, 2, 855.48468,-1404.04810,42.79400, -1);
		PVC2 = CreatePickup(359, 2, 853.05347,-1413.53149,42.79400, -1);
		PVC3 = CreatePickup(359, 2, 857.85236,-1413.68018,42.79400, -1);
		PVC4 = CreatePickup(359, 2, 855.66589,-1399.49414,42.79400, -1);
		PVC5 = CreatePickup(359, 2, 857.41882,-1389.55115,42.79400, -1);
		PVC6 = CreatePickup(359, 2, 853.15094,-1389.47656,42.79400, -1);
	}
	else if(PVC_Tipo == 3 && PVC_EmProgresso == 1 && PVC_EmProgresso == 1){
	 	PVC1 = CreatePickup(358, 2, 855.48468,-1404.04810,42.79400, -1);
		PVC2 = CreatePickup(358, 2, 853.05347,-1413.53149,42.79400, -1);
		PVC3 = CreatePickup(358, 2, 857.85236,-1413.68018,42.79400, -1);
		PVC4 = CreatePickup(358, 2, 855.66589,-1399.49414,42.79400, -1);
		PVC5 = CreatePickup(358, 2, 857.41882,-1389.55115,42.79400, -1);
		PVC6 = CreatePickup(358, 2, 853.15094,-1389.47656,42.79400, -1);
	}
return 1;}

forward PL_DefIniciar();
public PL_DefIniciar(){
PL_DominadoEntregar = false;
PL_Vencedor = 0;
//PL_Dominado = 0;
PL_Final = 0;
PL_Kills_1 = 0;
PL_Kills_2 = 0;
PL_Participantes = 0;
PL_Balancer = 0;
PL_Lobby = 0;
PL_EmProgresso = 1;
for(new i; i < GetMaxPlayers(); i++){
if(IsPlayerConnected(i)) {
if(IsPlayerSpawned(i)){
if(PL_Vai[i] == 1 && Arena[i] == 1) {PL_Vai[i] = 0;PL_PlayerCD[i] = 0;}
if(PL_Vai[i] == 1){
StuntSuperSpeed[i] = false;
PL_OldPlayerColor[i] = GetPlayerColor(i);
PL_Participantes++;
if(PL_Balancer == 0){
PL_Balancer = 1;
PL_Team[i] = 1;
}else{
PL_Balancer = 0;
PL_Team[i] = 2;}}}}}
if(PL_Participantes > 1){
new string[128];
format(string, sizeof(string), "[PL]: POLICIA X LADRAO: iniciou com %i participantes!", PL_Participantes);
SendClientMessageToAll(COLOUR_EVENTO, string);
}else{
new string[128];
format(string, sizeof(string), "[PL]: POLICIA X LADRAO: foi cancelado porque ninguem foi.");
SendClientMessageToAll(COLOUR_EVENTOCANCELADO, string);
PL_Lobby = 0;
PL_EmProgresso = 0;
for(new i; i < GetMaxPlayers(); i++){
if(IsPlayerConnected(i)){
PL_Vai[i] = 0;
PL_Team[i] = 0;}}
PL_Timer = SetTimer("PL_DefLobby",PL_TIME_IntervaloEntrePartidas, 0);
return 1;}
	for(new i; i < GetMaxPlayers(); i++){
		if(IsPlayerConnected(i)) {
			if(PL_Vai[i] == 1 && ArenaTipo[i] == 0) {
				if(PL_Team[i] == 1 && PL_EmProgresso == 1 && PL_Vai[i] == 1){
					PL_SpawnPlayer_1(i);
					PL_KillsPerPlayer[i] = 0;
				}
				if(PL_Team[i] == 2 && PL_EmProgresso == 1 && PL_Vai[i] == 1){
					PL_SpawnPlayer_2(i);
					PL_KillsPerPlayer[i] = 0;
				}
				SetPlayerCheckpoint(i, -1955.1580, 294.8524, 40.8340 , 6.0);
			}
		}
	}
	PL_TempSpawn = 6000000;
	for(new v; v<UltimoVeiculoGM; v++){
		if (GetVehicleDriver(v) == -1){
			SetVehicleToRespawn(v);
		}
	}
	
	PL_Timer = SetTimer("PL_DefFinalizar",PL_TIME_DuracaoDaPartida, 0);
	return 1;
}

forward PVC_RoundTrocar();
public PVC_RoundTrocar(){
	PVC_Round++;
	new string[300];

	PVC_Kills_1 = PVC_Morte_1;
	PVC_Kills_2 = PVC_Morte_2;
	if(PVC_Kills_1 > PVC_Kills_2){
		PVC_Vencedor = 1;
		PVC_Vencedor_STR = "TIME DE PLAYERS";
	}else if(PVC_Kills_1 < PVC_Kills_2){
		PVC_Vencedor = 2;
		if(PVC_Carro == true && PVC_Moto == false){
		    PVC_Vencedor_STR = "TIME DE CARROS";
		}else if(PVC_Moto == true && PVC_Carro == false){
		    PVC_Vencedor_STR = "TIME DE MOTOS";
		}
	}else if(PVC_Kills_1 == PVC_Kills_2){
		PVC_Vencedor = 3;
		PVC_Vencedor_STR = "EMPATE";
	}

	if(PVC_Kills_1 == PVC_Kills_2 && PVC_Vencedor == 3){
		if(PVC_Carro == true && PVC_Moto == false){
		    format(string, sizeof(string), "Combate PVC: [%s] [%i players] RODADA [%i] terminou em: %s (PLAYERS: %i x CARROS: %i)",PVC_Tipo_STR, PVC_Participantes, (PVC_Round-1), PVC_Vencedor_STR,PVC_Kills_1,PVC_Kills_2);
		}else if(PVC_Moto == true && PVC_Carro == false){
		    format(string, sizeof(string), "Combate PVC: [%s] [%i players] RODADA [%i] terminou em: %s (PLAYERS: %i x MOTOS: %i)",PVC_Tipo_STR, PVC_Participantes, (PVC_Round-1), PVC_Vencedor_STR,PVC_Kills_1,PVC_Kills_2);
		}
	}else{
	    if(PVC_Carro == true && PVC_Moto == false){
	    	format(string, sizeof(string), "Combate PVC: [%s] [%i players] RODADA [%i] terminou em: %s (PLAYERS: %i x CARROS: %i)",PVC_Tipo_STR, PVC_Participantes, (PVC_Round-1), PVC_Vencedor_STR,PVC_Kills_1,PVC_Kills_2);
		}else if(PVC_Moto == true && PVC_Carro == false){
		    format(string, sizeof(string), "Combate PVC: [%s] [%i players] RODADA [%i] terminou em: %s (PLAYERS: %i x MOTOS: %i)",PVC_Tipo_STR, PVC_Participantes, (PVC_Round-1), PVC_Vencedor_STR,PVC_Kills_1,PVC_Kills_2);
		}
	}
	SendClientMessageToAll(COLOUR_EVENTO, string);

	if(PVC_Round >= 2){
		PVC_Participantes = 0;
		PVC_EmProgresso = 1;

	    for(new i; i < GetMaxPlayers(); i++){
			if(IsPlayerConnected(i)) {
				if(PVC_Vai[i] == 1) {
					PVC_Participantes++;
			 		if(PVC_Team[i]==1){
                        PVC_Team[i]=2;
						PVC_SpawnPlayer_2(i);
					}else{
      					PVC_Team[i]=1;
      					PVC_SpawnPlayer_1(i);
					}
				}
			}
		}
	}
    PVC_Kills_1 = 0;
	PVC_Kills_2 = 0;
	PVC_Morte_1 = 0;
	PVC_Morte_2 = 0;
	if(PVC_Participantes > 1){
	}else{
		format(string, sizeof(string), "Combate PVC: [%s] terminou porque varios players desistiram.",PVC_Tipo_STR);
		KillTimer(PVC_Timer);
		PVC_DefFinalizar();
	}
	if(PVC_Participantes > 1){
		if(PVC_Round == 2){
			format(string, sizeof(string), "Combate PVC: [RODADA: %i] [%s] reiniciou com %i participantes!",PVC_Round, PVC_Tipo_STR, PVC_Participantes);
			SendClientMessageToAll(COLOUR_EVENTO, string);
			for(new i; i < GetMaxPlayers(); i++){
				if(IsPlayerConnected(i)) {
					if(IsPlayerSpawned(i)){
						if(PVC_Vai[i] == 1) {
							TextDrawShowForPlayer(i, Textdraw25);
							TextDrawShowForPlayer(i, Textdraw28);
							ContagemPVC(i);
						}
					}
				}
			}
			KillTimer(PVC_Timer);
			PVC_Timer = SetTimer("PVC_RoundTrocar",PVC_TIME_DuracaoDaPartida, 0);
		}
		if(PVC_Round == 3){
			format(string, sizeof(string), "Combate PVC: [RODADA: %i] [%s] reiniciou com %i participantes!",PVC_Round, PVC_Tipo_STR, PVC_Participantes);
			SendClientMessageToAll(COLOUR_EVENTO, string);
			for(new i; i < GetMaxPlayers(); i++){
				if(IsPlayerConnected(i)) {
					if(IsPlayerSpawned(i)){
						if(PVC_Vai[i] == 1) {
							TextDrawShowForPlayer(i, Textdraw25);
							TextDrawShowForPlayer(i, Textdraw29);
							ContagemPVC(i);
						}
					}
				}
			}
			KillTimer(PVC_Timer);
			PVC_Timer = SetTimer("PVC_RoundTrocar",PVC_TIME_DuracaoDaPartida, 0);
		}
		if(PVC_Round == 4){
			format(string, sizeof(string), "Combate PVC: [RODADA: %i] [%s] reiniciou com %i participantes!",PVC_Round, PVC_Tipo_STR, PVC_Participantes);
			SendClientMessageToAll(COLOUR_EVENTO, string);
			for(new i; i < GetMaxPlayers(); i++){
				if(IsPlayerConnected(i)) {
					if(IsPlayerSpawned(i)){
						if(PVC_Vai[i] == 1) {
							TextDrawShowForPlayer(i, Textdraw25);
							TextDrawShowForPlayer(i, Textdraw30);
							ContagemPVC(i);
						}
					}
				}
			}
			KillTimer(PVC_Timer);
			PVC_Timer = SetTimer("PVC_DefFinalizar",PVC_TIME_DuracaoDaPartida, 0);
		}
	}else{
		format(string, sizeof(string), "Combate PVC: [%s] foi cancelado.",PVC_Tipo_STR);
		SendClientMessageToAll(COLOUR_EVENTOCANCELADO, string);
		PVC_Lobby = 0;
		PVC_EmProgresso = 0;
		PVC_Escolher = false;
		for(new i; i < GetMaxPlayers(); i++){
			if(IsPlayerConnected(i)){
				PVC_Vai[i] = 0;
				PVC_Team[i] = 0;
			}
		}
		PVC_Timer = SetTimer("PVC_DefLobby",PVC_TIME_IntervaloEntrePartidas, 0);
		return 1;
	}
	return 1;
}

forward AAD_SpawnPlayer_1(i);
public AAD_SpawnPlayer_1(i){
RemoverTodosAttachsObj(i);
SetPlayerColor(i, 0xFF0000FF);
SetPlayerSkin(i, 29);
SetPlayerTeam(i, 1);
SetPlayerTeam(i, 1);
SetPlayerVirtualWorld(i, 20);
Arena[i] = 1;
ArenaTipo[i] = 10;
new rand = random(sizeof(AAD_PORTAO_SPAWNS));
SetPlayerPos(i, AAD_PORTAO_SPAWNS[rand][0], AAD_PORTAO_SPAWNS[rand][1], AAD_PORTAO_SPAWNS[rand][2]);
SetCameraBehindPlayer(i);
SetPlayerFacingAngle(i,AAD_PORTAO_SPAWNS[rand][3]);
ResetPlayerWeapons(i);
SetPlayerHealth(i,100);
SetPlayerArmour(i,100);
SetPlayerInterior(i,0);
switch(AAD_Tipo){
case 0:{
GivePlayerWeapon(i, 4, 2);
GivePlayerWeapon(i, 24, 9999);
GivePlayerWeapon(i, 27, 9999);
GivePlayerWeapon(i, 31, 9999);
GivePlayerWeapon(i, 34, 9999);
GivePlayerWeapon(i, 29, 9999);}
case 1:{
GivePlayerWeapon(i, 22, 9999);
GivePlayerWeapon(i, 28, 9999);
GivePlayerWeapon(i, 26, 9999);}
case 2:{
GivePlayerWeapon(i, 4, 2);
GivePlayerWeapon(i, 16, 9999);
GivePlayerWeapon(i, 24, 9999);
GivePlayerWeapon(i, 27, 9999);
GivePlayerWeapon(i, 29, 9999);
GivePlayerWeapon(i, 31, 9999);
GivePlayerWeapon(i, 34, 9999);}
case 3:{
GivePlayerWeapon(i, 24, 9999);}
case 4:{
GivePlayerWeapon(i, 24, 9999);
GivePlayerWeapon(i, 32, 9999);
GivePlayerWeapon(i, 34, 9999);
GivePlayerWeapon(i, 4, 9999);
GivePlayerWeapon(i, 27, 9999);
GivePlayerWeapon(i, 31, 9999);}}
SendClientMessage(i, COLOUR_INFORMACAO, " ");
SendClientMessage(i, COLOUR_INFORMACAO, "Você está no time do ATAQUE, sua missão é matar");
SendClientMessage(i, COLOUR_INFORMACAO, "o máximo possível de DEFENSORES (AZUIS) e/ou dominar");
SendClientMessage(i, COLOUR_INFORMACAO, "o checkpoint que eles defendem");
SendClientMessage(i, COLOUR_INFORMACAO, " ");
return 1;}

forward PVC_SpawnPlayer_1(i);
public PVC_SpawnPlayer_1(i){
RemoverTodosAttachsObj(i);
SetPlayerColor(i, 0xFF0000FF);
SetPlayerTeam(i, 1);
SetPlayerTeam(i, 1);
if(PVC_Carro == true && PVC_Moto == false){
SetPlayerVirtualWorld(i, 225);
}else if(PVC_Carro == false && PVC_Moto == true){
SetPlayerVirtualWorld(i, 224);
}
Arena[i] = 1;
ArenaTipo[i] = 69;
new rand = random(sizeof(PVC_PLAYERS));
SetPlayerPos(i, PVC_PLAYERS[rand][0], PVC_PLAYERS[rand][1], PVC_PLAYERS[rand][2]);
SetCameraBehindPlayer(i);
SetPlayerFacingAngle(i,PVC_PLAYERS[rand][3]);
ResetPlayerWeapons(i);
SetPlayerHealth(i,5);
SetPlayerArmour(i,0);
SetPlayerInterior(i,0);
switch(PVC_Tipo){
	case 0:{
		GivePlayerWeapon(i, 35, 50);}
	case 1:{
		GivePlayerWeapon(i, 34, 10);}
	case 2:{
	    GivePlayerWeapon(i, 35, 50);}
	case 3:{
	    GivePlayerWeapon(i, 34, 100);}
}
//CarregarCacar(i);
Streamer_Update(i);
if(PVC_Carro == true && PVC_Moto == false){
	SendClientMessage(i, COLOUR_INFORMACAO, " ");
	SendClientMessage(i, COLOUR_INFORMACAO, "Você está no time de PLAYERS, sua missão é DESTRUIR");
	SendClientMessage(i, COLOUR_INFORMACAO, "o máximo possível de CARROS (AZUIS)");
	SendClientMessage(i, COLOUR_INFORMACAO, " ");
}else if(PVC_Carro == false && PVC_Moto == true){
	SendClientMessage(i, COLOUR_INFORMACAO, " ");
	SendClientMessage(i, COLOUR_INFORMACAO, "Você está no time de PLAYERS, sua missão é DESTRUIR");
	SendClientMessage(i, COLOUR_INFORMACAO, "o máximo possível de MOTOS (AZUIS)");
	SendClientMessage(i, COLOUR_INFORMACAO, " ");
}
return 1;}

forward PL_SpawnPlayer_1(i);
public PL_SpawnPlayer_1(i){
RemoverTodosAttachsObj(i);
SetPlayerColor(i, 0x0000FFFF);
SetPlayerTeam(i, 1);
if(PL_Skin1 == 0){
	SetPlayerSkin(i, 280);
	PL_Skin1++;
}else if(PL_Skin1 == 1){
	SetPlayerSkin(i, 283);
	PL_Skin1++;
}else if(PL_Skin1 == 2){
	SetPlayerSkin(i, 285);
	PL_Skin1++;
}else if(PL_Skin1 == 3){
	SetPlayerSkin(i, 286);
	PL_Skin1++;
}else if(PL_Skin1 == 4){
	SetPlayerSkin(i, 287);
	PL_Skin1++;
}else if(PL_Skin1 == 5){
	SetPlayerSkin(i, 265);
	PL_Skin1 = 0;
}
SetPlayerVirtualWorld(i, 2626);
Arena[i] = 1;
ArenaTipo[i] = 26;
new rand = random(sizeof(PL_POLICIA));
SetPlayerPos(i, PL_POLICIA[rand][0], PL_POLICIA[rand][1], PL_POLICIA[rand][2]);
SetCameraBehindPlayer(i);
SetPlayerFacingAngle(i,PL_POLICIA[rand][3]);
ResetPlayerWeapons(i);
SetPlayerHealth(i,100);
SetPlayerArmour(i,100);
SetPlayerInterior(i,0);
GivePlayerWeapon(i, 4, 2);
GivePlayerWeapon(i, 16, 999);
GivePlayerWeapon(i, 24, 999);
GivePlayerWeapon(i, 26, 999);
GivePlayerWeapon(i, 28, 999);
GivePlayerWeapon(i, 31, 999);
GivePlayerWeapon(i, 34, 999);
GivePlayerWeapon(i, 31, 999);
GivePlayerWeapon(i, 41, 999);
GivePlayerWeapon(i, 46, 999);
GivePlayerWeapon(i, 1, 1);
ContagemPL(i);
Streamer_Update(i);
SendClientMessage(i, COLOUR_INFORMACAO, " ");
SendClientMessage(i, COLOUR_INFORMACAO, "Você está no time de POLICIAIS, sua missão é imperdir que ROUBEM O CARRO!");
SendClientMessage(i, COLOUR_INFORMACAO, "Mate o maximo de LADROES (marrom) para eviar que");
SendClientMessage(i, COLOUR_INFORMACAO, "Roubem o CARRO (Slamvan)!");
SendClientMessage(i, COLOUR_INFORMACAO, " ");
return 1;}

forward PL_SpawnPlayer_2(i);
public PL_SpawnPlayer_2(i){
RemoverTodosAttachsObj(i);
SetPlayerColor(i, 0x876F7AFF);
SetPlayerTeam(i, 2);
SetPlayerTeam(i, 2);
SetPlayerVirtualWorld(i, 2626);
if(PL_Skin2 == 0){
	SetPlayerSkin(i, 28);
	PL_Skin2++;
}else if(PL_Skin2 == 1){
	SetPlayerSkin(i, 29);
	PL_Skin2++;
}else if(PL_Skin2 == 1){
	SetPlayerSkin(i, 30);
	PL_Skin2++;
}else if(PL_Skin2 == 1){
	SetPlayerSkin(i, 47);
	PL_Skin2++;
}else if(PL_Skin2 == 1){
	SetPlayerSkin(i, 102);
	PL_Skin2++;
}else if(PL_Skin2 == 1){
	SetPlayerSkin(i, 108);
	PL_Skin2 = 0;
}
Arena[i] = 1;
ArenaTipo[i] = 26;
GodCarOn[i] = 0;
new rand = random(sizeof(PL_LADRAO));
SetPlayerPos(i, PL_LADRAO[rand][0], PL_LADRAO[rand][1], PL_LADRAO[rand][2]);
SetCameraBehindPlayer(i);
SetPlayerFacingAngle(i,PL_LADRAO[rand][3]);
ResetPlayerWeapons(i);
GivePlayerWeapon(i, 4, 2);
GivePlayerWeapon(i, 16, 999);
GivePlayerWeapon(i, 24, 999);
GivePlayerWeapon(i, 26, 999);
GivePlayerWeapon(i, 28, 999);
GivePlayerWeapon(i, 31, 999);
GivePlayerWeapon(i, 34, 999);
GivePlayerWeapon(i, 31, 999);
GivePlayerWeapon(i, 41, 999);
GivePlayerWeapon(i, 46, 999);
GivePlayerWeapon(i, 1, 1);
SetPlayerHealth(i,100);
SetPlayerArmour(i,100);
SetPlayerInterior(i,0);
ContagemPL(i);
Streamer_Update(i);
SendClientMessage(i, COLOUR_INFORMACAO, " ");
SendClientMessage(i, COLOUR_INFORMACAO, "Você está no time dos LADROES, sua missão é roubar o carro!.");
SendClientMessage(i, COLOUR_INFORMACAO, "Mate o maximo de POLICIAIS(azuis) e roube o carro (Slanvan)!");
SendClientMessage(i, COLOUR_INFORMACAO, " ");
return 1;}

forward AAD_SpawnPlayer_2(i);
public AAD_SpawnPlayer_2(i){
RemoverTodosAttachsObj(i);
SetPlayerColor(i, 0x0000FFFF);
SetPlayerSkin(i, 28);
SetPlayerTeam(i, 2);
SetPlayerTeam(i, 2);
SetPlayerVirtualWorld(i, 20);
Arena[i] = 1;
ArenaTipo[i] = 10;
new rand = random(sizeof(AAD_CASA_SPAWNS));
SetPlayerPos(i, AAD_CASA_SPAWNS[rand][0], AAD_CASA_SPAWNS[rand][1], AAD_CASA_SPAWNS[rand][2]);
SetCameraBehindPlayer(i);
SetPlayerFacingAngle(i,AAD_CASA_SPAWNS[rand][3]);
ResetPlayerWeapons(i);
SetPlayerHealth(i,100);
SetPlayerArmour(i,100);
SetPlayerInterior(i,0);
switch(AAD_Tipo){
case 0:{
GivePlayerWeapon(i, 4, 2);
GivePlayerWeapon(i, 24, 9999);
GivePlayerWeapon(i, 27, 9999);
GivePlayerWeapon(i, 31, 9999);
GivePlayerWeapon(i, 34, 9999);
GivePlayerWeapon(i, 29, 9999);}
case 1:{
GivePlayerWeapon(i, 22, 9999);
GivePlayerWeapon(i, 28, 9999);
GivePlayerWeapon(i, 26, 9999);}
case 2:{
GivePlayerWeapon(i, 4, 2);
GivePlayerWeapon(i, 16, 9999);
GivePlayerWeapon(i, 24, 9999);
GivePlayerWeapon(i, 27, 9999);
GivePlayerWeapon(i, 29, 9999);
GivePlayerWeapon(i, 31, 9999);
GivePlayerWeapon(i, 34, 9999);}
case 3:{
GivePlayerWeapon(i, 24, 9999);}
case 4:{
GivePlayerWeapon(i, 24, 9999);
GivePlayerWeapon(i, 32, 9999);
GivePlayerWeapon(i, 34, 9999);
GivePlayerWeapon(i, 4, 9999);
GivePlayerWeapon(i, 27, 9999);
GivePlayerWeapon(i, 31, 9999);}}
SendClientMessage(i, COLOUR_INFORMACAO, " ");
SendClientMessage(i, COLOUR_INFORMACAO, "Você está no time da DEFESA, sua missão é defender");
SendClientMessage(i, COLOUR_INFORMACAO, "o seu lado e evitar que o time oposto domine o");
SendClientMessage(i, COLOUR_INFORMACAO, "checkpoint vermelho.");
SendClientMessage(i, COLOUR_INFORMACAO, " ");
return 1;}

forward PVC_SpawnPlayer_2(i);
public PVC_SpawnPlayer_2(i){
RemoverTodosAttachsObj(i);
SetPlayerColor(i, 0x0000FFFF);
SetPlayerTeam(i, 2);
SetPlayerTeam(i, 2);
if(PVC_Carro == true && PVC_Moto == false){
SetPlayerVirtualWorld(i, 225);
}else if(PVC_Carro == false && PVC_Moto == true){
SetPlayerVirtualWorld(i, 224);
}
Arena[i] = 1;
ArenaTipo[i] = 69;
GodCarOn[i] = 0;
new rand = random(sizeof(PVC_CARROS));
SetPlayerPos(i, PVC_CARROS[rand][0], PVC_CARROS[rand][1], PVC_CARROS[rand][2]);
SetCameraBehindPlayer(i);
SetPlayerFacingAngle(i,PVC_CARROS[rand][3]);
ResetPlayerWeapons(i);
GivePlayerWeapon(i, 4, 1);
SetPlayerHealth(i,100);
SetPlayerArmour(i,0);
SetPlayerInterior(i,0);
//CarregarCacar(i);
Streamer_Update(i);
if(PVC_Carro == true && PVC_Moto == false){
	SendClientMessage(i, COLOUR_INFORMACAO, " ");
	SendClientMessage(i, COLOUR_INFORMACAO, "Você está no time dos CARROS, sua missão é derrubar ou matar atropelando.");
	SendClientMessage(i, COLOUR_INFORMACAO, " ");
}else if(PVC_Carro == false && PVC_Moto == true){
	SendClientMessage(i, COLOUR_INFORMACAO, " ");
	SendClientMessage(i, COLOUR_INFORMACAO, "Você está no time dos MOTOS, sua missão é derrubar ou matar atropelando.");
	SendClientMessage(i, COLOUR_INFORMACAO, " ");
}
return 1;}

forward EAM_FinalizaLobby(adminid);
public EAM_FinalizaLobby(adminid){
	for(new i; i < GetMaxPlayers(); i++){
		if(IsPlayerConnected(i)){
			if(EAM_Player[i] == true){
				SpawnPlayer(i);
			}
				DisablePlayerCheckpoint(i);
		}
	}
	new string[128],pname[MAX_PLAYER_NAME];
	GetPlayerName(adminid, pname, sizeof(pname));
	format(string, sizeof(string), "[EAM]: [%s] foi cancelado pelo administrador %s!",EAM_Tipo_STR,pname);
	SendClientMessageToAll(COLOUR_EVENTOCANCELADO, string);
	EAM_EmProgresso = 0;
	EAM_Lobby = 0;
	KillTimer(EAM_Timer);
	EAM_Timer = SetTimer("EAM_DefLobby",EAM_TIME_IntervaloEntrePartidas, 0);
	return 1;
}

forward AAD_DefFinalizar();
public AAD_DefFinalizar()
{
AAD_Lobby = 0;
AAD_EmProgresso = 0;

new MaiorKill = 0;
for(new x,a = GetMaxPlayers();x < a;x++){if(IsPlayerConnected(x)){
if(AAD_Vai[x] == 1){
if(AAD_Team[x] != 0){
if(AAD_KillsPerPlayer[x] >= MaiorKill) {
MaiorKill = AAD_KillsPerPlayer[x];
AAD_TopKillerID = x;}}}}}

AAD_TopKillerID_Kills = MaiorKill;
GetPlayerName(AAD_TopKillerID, AAD_TopKillerID_NAME, sizeof(AAD_TopKillerID_NAME));

if(AAD_TopKillerID_Kills < 1){
AAD_TopKillerID = 0;
AAD_TopKillerID_Kills = 0;
AAD_TopKillerID_NAME = "Ninguem";}

if(AAD_Dominado == 1){
AAD_Vencedor = 1;
AAD_Vencedor_STR = "TIME DE ATAQUE";
AAD_Vencedor = 1;}else{
AAD_Vencedor = 2;
AAD_Vencedor_STR = "TIME DE DEFESA";}

for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){
if(AAD_Vai[i] == 1){
DisablePlayerCheckpoint(i);
SetPlayerColor(i, AAD_OldPlayerColor[i]);
SpawnPlayer(i);}
AAD_Vai[i] = 0;
AAD_Team[i] = 0;}}
new string[128];
format(string, sizeof(string), "Combate A/D: [%s] [%i players] Vencedor: %s (Ataque %i x Defesa %i) [Melhor: %s com %i kills]",AAD_Tipo_STR,AAD_Participantes,AAD_Vencedor_STR,AAD_Kills_1,AAD_Kills_2,AAD_TopKillerID_NAME,AAD_TopKillerID_Kills);
SendClientMessageToAll(COLOUR_EVENTO, string);
if(AAD_TopKillerID == 0){/*NADA AQUI*/}
if(AAD_Vencedor == 0){/*NADA AQUI*/}
AAD_Timer = SetTimer("AAD_DefLobby",AAD_TIME_IntervaloEntrePartidas, 0);}

forward PVC_DefFinalizar();
public PVC_DefFinalizar()
{
	//DESTROY PICKUP CARROS VS PLAYERS GTA V BY MOTOXEX
	DestroyPickup(PVC1);
	DestroyPickup(PVC2);
	DestroyPickup(PVC3);
	DestroyPickup(PVC4);
	DestroyPickup(PVC5);
	DestroyPickup(PVC6);
	
	for(new x=0; x<51; x++){
		DestroyObject(PVC_Objetos[x]);
	}
	
	PVC_Escolher = false;
	PVC_Lobby = 0;
	PVC_EmProgresso = 0;

	if(PVC_Morte_A > PVC_Morte_B){
		PVC_Vencedor = 1;
		PVC_Vencedor_STR = "TIME B";
	}else if(PVC_Morte_A < PVC_Morte_B){
		PVC_Vencedor = 2;
		if(PVC_Carro == true && PVC_Moto == false){
		    PVC_Vencedor_STR = "TIME A";
		}else if(PVC_Moto == true && PVC_Carro == false){
		    PVC_Vencedor_STR = "TIME A";
		}
	}else if(PVC_Kills_1 == PVC_Kills_2){
		PVC_Vencedor = 3;
		PVC_Vencedor_STR = "EMPATE";
	}

	for(new i; i < GetMaxPlayers(); i++){
		if(IsPlayerConnected(i)){
			if(PVC_Vai[i] == 1){
				SetPlayerColor(i, PVC_OldPlayerColor[i]);
				SpawnPlayer(i);
				
			}
			PVC_Vai[i] = 0;
			PVC_Team[i] = 0;
		}
	}
	new string[300];
	if(PVC_Kills_1 == PVC_Kills_2 && PVC_Vencedor == 3){
		if(PVC_Carro == true && PVC_Moto == false){
		    format(string, sizeof(string), "Combate PVC: [%s] [%i players] Terminou em: %s (TIME A %i x TIME B: %i)",PVC_Tipo_STR, PVC_Participantes,PVC_Vencedor_STR,PVC_Morte_A,PVC_Morte_B);
		}else if(PVC_Moto == true && PVC_Carro == false){
		    format(string, sizeof(string), "Combate PVC: [%s] [%i players] Terminou em: %s ((TIME A %i x TIME B: %i)",PVC_Tipo_STR, PVC_Participantes,PVC_Vencedor_STR,PVC_Morte_A,PVC_Morte_B);
		}
	}else{
	    if(PVC_Carro == true && PVC_Moto == false){
	    	format(string, sizeof(string), "Combate PVC: [%s] [%i players] Vencedor: %s (TIME A %i x TIME B: %i)",PVC_Tipo_STR, PVC_Participantes,PVC_Vencedor_STR,PVC_Morte_A,PVC_Morte_B);
		}else if(PVC_Moto == true && PVC_Carro == false){
		    format(string, sizeof(string), "Combate PVC: [%s] [%i players] Vencedor: %s (TIME A %i x TIME B: %i)",PVC_Tipo_STR, PVC_Participantes,PVC_Vencedor_STR,PVC_Morte_A,PVC_Morte_B);
		}
	}
	SendClientMessageToAll(COLOUR_EVENTO, string);
	PVC_Moto = false;
	PVC_Moto = false;
	PVC_Round = 0;
	KillTimer(PVC_Timer);
	PVC_Timer = SetTimer("PVC_DefLobby",PVC_TIME_IntervaloEntrePartidas, 0);
}

forward PL_DefFinalizar();
public PL_DefFinalizar(){
PL_Lobby = 0;
PL_Vencedor = 0;
PL_EmProgresso = 0;
new MaiorKill = 0;
for(new x,a = GetMaxPlayers();x < a;x++){if(IsPlayerConnected(x)){
	if(PL_Vai[x] == 1){
	    DisablePlayerCheckpoint(x);
	if(PL_Team[x] != 0){
	if(PL_KillsPerPlayer[x] >= MaiorKill) {
	MaiorKill = PL_KillsPerPlayer[x];
	PL_TopKillerID = x;}}}}}

PL_TopKillerID_Kills = MaiorKill;
GetPlayerName(PL_TopKillerID, PL_TopKillerID_NAME, sizeof(PL_TopKillerID_NAME));

if(PL_TopKillerID_Kills < 1){
PL_TopKillerID = 0;
PL_TopKillerID_Kills = 0;
PL_TopKillerID_NAME = "Ninguem";}

if(PL_DominadoEntregar == false){
	new cashpl;
	PL_Vencedor_STR = "POLICIAIS";
	PL_Vencedor = 1;
	new string[300];
	format(string, sizeof(string), "[PL]: POLICIA X LADRAO: Os policiais conseguiram impedir a entrega do carro!!");
	SendClientMessageToAll(COLOUR_INFORMACAO, string);
	cashpl = PL_Participantes*10000;
    for(new i; i < GetMaxPlayers(); i++){
		if(IsPlayerConnected(i)){
			if(PL_Vai[i] == 1 && PL_Vencedor == 1 && PL_Team[i] == 1){
                CallRemoteFunction("GivePlayerCash", "ii", i, cashpl);
                format(string, sizeof(string), "[PL]: O time todo ganhou R$%i.", cashpl);
                SendClientMessage(i, COLOUR_INFORMACAO, string);
			}
		}
	}
}else{
	new cashpl;
	PL_Vencedor_STR = "LADROES";
	PL_Vencedor = 2;
	new string[300];
	new pCD[MAX_PLAYER_NAME];
	cashpl = PL_Participantes*10000;
	for(new i; i < GetMaxPlayers(); i++){
		if(IsPlayerConnected(i)){
			if(PL_Vai[i] == 1 && PL_Vencedor == 2 && PL_Team[i] == 2){
                CallRemoteFunction("GivePlayerCash", "ii", i, cashpl);
                format(string, sizeof(string), "[PL]: O time todo ganhou R$%i.", cashpl);
                SendClientMessage(i, COLOUR_INFORMACAO, string);
                if(PL_PlayerCD[i] == 1){
					GetPlayerName(i, pCD, MAX_PLAYER_NAME);
				}
			}
		}
	}
	format(string, sizeof(string), "[PL]: POLICIA X LADRAO: Os ladroes conseguiram entregar o carro ao destino!");
	SendClientMessageToAll(COLOUR_INFORMACAO, string);
    format(string, sizeof(string), "[PL]: Destaque para o player {FFFFFF}%s{21CC21}, conseguiu fazer a entrega!", pCD);
    SendClientMessageToAll(COLOUR_INFORMACAO, string);
}

for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){
	if(PL_Vai[i] == 1){
		SetPlayerColor(i, PL_OldPlayerColor[i]);
		SpawnPlayer(i);
	}
	PL_Vai[i] = 0;
	PL_Team[i] = 0;
	PL_Vencedor = 0;
	PL_PlayerCD[i] = 0;
	}
}
new string[128];
format(string, sizeof(string), "[PL]: POLICIA X LADRAO: [%i players] Vencedor: %s (POLICIA matou: [%i] x LADRAO matou: [%i])", PL_Participantes,PL_Vencedor_STR,PL_Kills_1,PL_Kills_2);
SendClientMessageToAll(COLOUR_EVENTO, string);
//PL_TempSpawn = 15;
PL_Timer = SetTimer("PL_DefLobby",PL_TIME_IntervaloEntrePartidas, 0);
}

forward AAD_DefLobby();
public AAD_DefLobby(){
AAD_Tipo = random(5);
switch(AAD_Tipo){
case 0: AAD_Tipo_STR = "WALK";
case 1: AAD_Tipo_STR = "RUN";
case 2: AAD_Tipo_STR = "WALK + GRANADA";
case 3: AAD_Tipo_STR = "DESERT EAGLE";
case 4: AAD_Tipo_STR = "MISTO";}
AAD_Lobby = 0;
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){
AAD_Vai[i] = 0;
AAD_Team[i] = 0;}}
AAD_Lobby = 1;
AAD_EmProgresso = 0;
new string[128];
format(string, sizeof(string), "Combate A/D: [%s] iniciando em instantes... ( Participar: /AD )",AAD_Tipo_STR);
SendClientMessageToAll(COLOUR_EVENTO, string);
AAD_Timer = SetTimer("AAD_DefIniciar",AAD_TIME_TempoDeEsperaLobby, 0);}

forward EAM_DefFinalizar(playerid);
public EAM_DefFinalizar(playerid){
	new string[300];
    new pname[MAX_PLAYER_NAME];
    new quantPlayersOns;
	GetPlayerName(playerid, pname, MAX_PLAYER_NAME);

	if(EAM_ESC[playerid] == true && EAM_Checkpoint[playerid] == false){
		format(string, sizeof(string), "[EAM]: O player {FFFFFF}%s {FF5A00}ficou de ESC por muito tempo e por isso ninguem ganhou!!", pname);
		SendClientMessageToAll(COLOUR_EVENTO, string);
		format(string, sizeof(string), "[EAM]: Voce ficou muito tempo de ESC, cuide na proxima!!");
		SendClientMessage(playerid, COLOUR_INFORMACAO, string);
	}
	if(EAM_PlayerMorto == false && EAM_Tipo == 0 && EAM_Checkpoint[playerid] == true && PL_Vai[playerid] == 0){
    	for(new i; i < GetMaxPlayers(); i++){
			if(IsPlayerConnected(i)){
				quantPlayersOns++;
			}
		}
		format(string, sizeof(string), "[EAM]: O player {FFFFFF}%s {FF5A00}ganhou o SUPER PREMIO por ficar vivo no tempo definido!!", pname);
		SendClientMessageToAll(COLOUR_EVENTO, string);
		quantPlayersOns = 20000*quantPlayersOns;
		format(string, sizeof(string), "[EAM]: Voce ganhou R$%i por sobreviver no tempo definido! Parabens!!", quantPlayersOns);
		SendClientMessage(playerid, COLOUR_INFORMACAO, string);
		CallRemoteFunction("GivePlayerCash", "ii", playerid, quantPlayersOns);
	}else if(EAM_QuantPlayer == false && EAM_Checkpoint[playerid] == false){
	    format(string, sizeof(string), "[EAM]: Ninguem conseguiu chegar a tempo no checkpoint! Logo tera outro evento!!");
		SendClientMessageToAll(COLOUR_EVENTO, string);
	}

	for(new i; i < GetMaxPlayers(); i++){
		if(IsPlayerConnected(i)){
			DisablePlayerCheckpoint(i);
		}
	}
	EAM_ESC[playerid] = false;
	EAM_Escolher = false;
	EAM_QuantPlayer = false;
	EAM_PlayerMorto = false;
	EAM_EmProgresso = 0;
	EAM_Lobby = 0;
	EAM_Player[playerid] = false;
	EAM_Checkpoint[playerid] = false;
	EventoProibirTeleEAM[playerid] = false;
	KillTimer(EAM_Timer);
	EAM_Timer = SetTimer("EAM_DefLobby",EAM_TIME_IntervaloEntrePartidas, 0);
}

forward PVC_DefLobby();
public PVC_DefLobby(){
if(PVC_Escolher == true){
	switch(PVC_Tipo){
		case 0:{
			PVC_Tipo_STR = "RPGxCARROS";
			PVC_Carro = true;
			PVC_Moto = false;}
		case 1:{
			PVC_Tipo_STR = "SNIPERxCARROS";
			PVC_Carro = true;
			PVC_Moto = false;}
		case 2:{
			PVC_Tipo_STR = "RPGxMOTOS";
			PVC_Carro = false;
			PVC_Moto = true;}
		case 3:{
			PVC_Tipo_STR = "SNIPERxMOTOS";
			PVC_Carro = false;
			PVC_Moto = true;}
	}
}else if(PVC_Escolher == false){
	PVC_Tipo = 0;
	PVC_Tipo = random(4);
	switch(PVC_Tipo){
		case 0:{
			PVC_Tipo_STR = "RPGxCARROS";
			PVC_Carro = true;
			PVC_Moto = false;}
		case 1:{
			PVC_Tipo_STR = "SNIPERxCARROS";
			PVC_Carro = true;
			PVC_Moto = false;}
		case 2:{
			PVC_Tipo_STR = "RPGxMOTOS";
			PVC_Carro = false;
			PVC_Moto = true;}
		case 3:{
			PVC_Tipo_STR = "SNIPERxMOTOS";
			PVC_Carro = false;
			PVC_Moto = true;}
	}
}

PVC_Lobby = 0;
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){
PVC_Vai[i] = 0;
PVC_Team[i] = 0;}}
PVC_Lobby = 1;
PVC_EmProgresso = 0;
new string[128];
format(string, sizeof(string), "Combate PVC: [%s] iniciando em instantes... ( Participar: /PVC )", PVC_Tipo_STR);
SendClientMessageToAll(COLOUR_EVENTO, string);
KillTimer(PVC_Timer);
PVC_Timer = SetTimer("PVC_DefIniciar",PVC_TIME_TempoDeEsperaLobby, 0);}

forward EAM_DefLobby();
public EAM_DefLobby(){
	if(EAM_Escolher == false){
		EAM_Tipo = random(2);
	}
	switch(EAM_Tipo){
		case 0:{
			EAM_Tipo_STR = "CAÇADA AO PLAYER";}
		case 1:{
			EAM_Tipo_STR = "CHEGOU GANHOU";}
		/*case 2:{
			EAM_Tipo_STR = "";}
		case 3:{
			EAM_Tipo_STR = "";}*/
	}
	EAM_EmProgresso = 0;
	EAM_Lobby = 1;
	KillTimer(EAM_Timer);
	EAM_Timer = SetTimer("EAM_DefIniciar",EAM_TIME_TempoDeEsperaLobby, 0);
}

forward PL_DefLobby();
public PL_DefLobby(){
PL_Lobby = 0;
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){
PL_Vai[i] = 0;
PL_Team[i] = 0;}}
PL_Lobby = 1;
PL_EmProgresso = 0;
new string[128];
format(string, sizeof(string), "[PL]: POLICIA X LADRAO: iniciando em instantes... ( Participar: /PL )");
SendClientMessageToAll(COLOUR_EVENTO, string);
PL_Timer = SetTimer("PL_DefIniciar",PL_TIME_TempoDeEsperaLobby, 0);}

MostrarDialogoEfeitos(playerid){
ShowPlayerDialog(playerid,987,DIALOG_STYLE_LIST,"Escolha um efeito especial:","{FF0000}Nenhum efeito (Remover)\nFogo\nFumaça\nChuveiro\nAbdução\nEstrelas\nÁgua","Selecionar","Voltar");
return 1;}

stock MostrarDialogoAcessorios1(playerid){
ShowPlayerDialog(playerid,995,DIALOG_STYLE_LIST,"Escolha um acessório:","{FF0000}Nenhum acessório (Remover)\nFantasia de tartaruga\nFantasia de bomba de gasolina\nBola na cabeça\nTelevisão na cabeça\nMáscara de caveira\nColt M4 nas costas\nEspada Katana nas costas\nExtintor de incêndio nas costas\nParquedas (Mochila)\nExplosivo (Homem Bomba)\nBandeira verde\nParaquedas aberto\nClarão (Hydra Flare)\nDildo na frente\nDildo atrás\nCoração no peito\nMais acessorios...","Selecionar","Voltar");
return 1;}

stock MostrarDialogoAcessorios2(playerid){
ShowPlayerDialog(playerid,996,DIALOG_STYLE_LIST,"Escolha um acessório:","Fantasia de vaca\nBola de basquete na cabeça\nPênis no skin\nFantasia de tubarão\nCaixa fumegando\nDinamite\nChapéu modelo 1\nChapéu modelo 2\nChapéu modelo 3\nChapéu modelo 4\nAparelho de som\nSeta de destaque\nChapéu de cone\nPizza na mão\nProtetor solar\nCelular na mão\nCubo na cabeça\nMais acessorios...","Selecionar","Voltar");
return 1;}

stock MostrarDialogoAcessorios3(playerid){
ShowPlayerDialog(playerid,997,DIALOG_STYLE_LIST,"Escolha um acessório:","Dado na cabeça\nÁgua viva na cabeça 1\nÁgua viva na cabeça 2\nCastelo de areia na cabeça\nAeromodelo na cabeça\nCarrinho na cabeça\nHamburguer na cabeça\nCabeça de veado morto\nCorrente no pescoço\nColete no corpo\nSniper atrás\nBazuca atrás\nGarrafão verde\nTaça de vinho\nHambúrguer na mão\nVassoura na mão\nFantasia de hipopótamo\nOstra no pescoço\nMais acessorios...","Selecionar","Voltar");
return 1;}

stock MostrarDialogoAcessorios4(playerid){
ShowPlayerDialog(playerid,986,DIALOG_STYLE_LIST,"Escolha um acessório:","Cabeça de pião\nCesto de lixo\nPoste branco\nLuz branca\nSoda machine\nTampa de caldeirão\nPedra\nArco na cintura\nOrelhão\nCaçamba de lixo\nPoste de três cores\nEstátua de um leão\nGorro do Papai Noel","Selecionar","Voltar");
return 1;}

forward API_Teleporte(playerid, Float:X,Float:Y,Float:Z,Float:angulo,nome[],EmObjeto,interior);
public API_Teleporte(playerid, Float:X,Float:Y,Float:Z,Float:angulo,nome[],EmObjeto,interior){
if(!IsPlayerSpawned(playerid)){return 1;}
if(EventoProibirTele == true && NoEvento[playerid] == 1 && EventoAtivo == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[3]);
if(EventoProibirTeleEAM[playerid] == true) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Voce nao pode usar teleports no evento EAM!");
if(preso[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não pode usar comandos na cadeia!");
if(VPlayerMissao[playerid] != 0) return SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Você não pode usar teleportes em missões!");
if(Arena[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(Arena2[playerid] == 1) return SendClientMessage(playerid, COLOUR_ERRO, StringTable[0]);
if(ChecarVeiculosProibidosParaTele(playerid) == 1){return SendClientMessage(playerid, COLOUR_ERRO, StringTable[1]);}
if(ChecarAntiFlood(playerid)) return AntiFloodMsg(playerid);
new pname[MAX_PLAYER_NAME],string[200];GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para %s", pname,nome);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
SetPlayerInterior(playerid,interior);if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
SetVehiclePos(GetPlayerVehicleID(playerid),X,Y,Z+10);
SetVehicleZAngle(GetPlayerVehicleID(playerid), angulo);}else{
SetPlayerPos(playerid,X,Y,Z);SetCameraBehindPlayer(playerid);
if(EmObjeto == 1){Carregar(playerid);Streamer_Update(playerid);}
SetPlayerFacingAngle(playerid,angulo);}
if(IsPlayerInAnyVehicle(playerid) && EmObjeto == 1){SendClientMessage(playerid, COLOUR_INFORMACAO, StringTable[5]);}
SetCameraBehindPlayer(playerid);
ProgramarAntiFlood(playerid);
return 1;}


stock PVA()
{
new aleat = random(20);
if(aleat == 0) return 159;
if(aleat == 1) return 152;
if(aleat == 2) return 144;
if(aleat == 3) return 237;
if(aleat == 4) return 240;
if(aleat == 5) return 101;
if(aleat == 6) return 121;
if(aleat == 7) return 151;
if(aleat == 8) return 147;
if(aleat == 9) return 605;
if(aleat == 10) return 158;
if(aleat == 11) return 152;
if(aleat == 12) return 0;
if(aleat == 13) return 1;
if(aleat == 14) return 166;
if(aleat == 15) return 278;
if(aleat == 16) return 288;
if(aleat == 17) return 6;
if(aleat == 18) return 398;
if(aleat == 19) return 643;
return 1;
}



stock AutoTune(vehicleid)
{
//PINTURA
ChangeVehicleColor(vehicleid, PVA(), PVA());
//PAINTJOBS
new rdn01 = random(5);
switch(rdn01)
{
case 0:ChangeVehiclePaintjob(vehicleid,0);
case 1:ChangeVehiclePaintjob(vehicleid,1);
case 2:ChangeVehiclePaintjob(vehicleid,2);
case 3:ChangeVehiclePaintjob(vehicleid,3);
case 4:ChangeVehiclePaintjob(vehicleid,4);
}
//ESCAPES
new rdn02 = random(24);
switch(rdn02)
{
case 0:AddVehicleComponent(vehicleid,1034);
case 1:AddVehicleComponent(vehicleid,1046);
case 2:AddVehicleComponent(vehicleid,1065);
case 3:AddVehicleComponent(vehicleid,1064);
case 4:AddVehicleComponent(vehicleid,1028);
case 5:AddVehicleComponent(vehicleid,1089);
case 6:AddVehicleComponent(vehicleid,1037);
case 7:AddVehicleComponent(vehicleid,1045);
case 8:AddVehicleComponent(vehicleid,1066);
case 9:AddVehicleComponent(vehicleid,1059);
case 10:AddVehicleComponent(vehicleid,1029);
case 11:AddVehicleComponent(vehicleid,1092);
case 12:AddVehicleComponent(vehicleid,1044);
case 13:AddVehicleComponent(vehicleid,1126);
case 14:AddVehicleComponent(vehicleid,1129);
case 15:AddVehicleComponent(vehicleid,1104);
case 16:AddVehicleComponent(vehicleid,1113);
case 17:AddVehicleComponent(vehicleid,1136);
case 18:AddVehicleComponent(vehicleid,1043);
case 19:AddVehicleComponent(vehicleid,1127);
case 20:AddVehicleComponent(vehicleid,1132);
case 21:AddVehicleComponent(vehicleid,1105);
case 22:AddVehicleComponent(vehicleid,1114);
case 23:AddVehicleComponent(vehicleid,1135);
}
//FRONT BUMPER
new rdn03 = random(24);
switch(rdn03)
{
case 0:AddVehicleComponent(vehicleid,1171);
case 1:AddVehicleComponent(vehicleid,1153);
case 2:AddVehicleComponent(vehicleid,1160);
case 3:AddVehicleComponent(vehicleid,1155);
case 4:AddVehicleComponent(vehicleid,1169);
case 5:AddVehicleComponent(vehicleid,1166);
case 6:AddVehicleComponent(vehicleid,1172);
case 7:AddVehicleComponent(vehicleid,1152);
case 8:AddVehicleComponent(vehicleid,1173);
case 9:AddVehicleComponent(vehicleid,1157);
case 10:AddVehicleComponent(vehicleid,1170);
case 11:AddVehicleComponent(vehicleid,1165);
case 12:AddVehicleComponent(vehicleid,1174);
case 13:AddVehicleComponent(vehicleid,1179);
case 14:AddVehicleComponent(vehicleid,1189);
case 15:AddVehicleComponent(vehicleid,1182);
case 16:AddVehicleComponent(vehicleid,1115);
case 17:AddVehicleComponent(vehicleid,1191);
case 18:AddVehicleComponent(vehicleid,1175);
case 19:AddVehicleComponent(vehicleid,1185);
case 20:AddVehicleComponent(vehicleid,1188);
case 21:AddVehicleComponent(vehicleid,1181);
case 22:AddVehicleComponent(vehicleid,1116);
case 23:AddVehicleComponent(vehicleid,1190);
}

//REAR BUMPER
new rdn04 = random(25);
switch(rdn04)
{
case 1:AddVehicleComponent(vehicleid,1149);
case 2:AddVehicleComponent(vehicleid,1150);
case 3:AddVehicleComponent(vehicleid,1159);
case 4:AddVehicleComponent(vehicleid,1154);
case 5:AddVehicleComponent(vehicleid,1141);
case 6:AddVehicleComponent(vehicleid,1168);
case 7:AddVehicleComponent(vehicleid,1148);
case 8:AddVehicleComponent(vehicleid,1151);
case 9:AddVehicleComponent(vehicleid,1161);
case 10:AddVehicleComponent(vehicleid,1156);
case 11:AddVehicleComponent(vehicleid,1140);
case 12:AddVehicleComponent(vehicleid,1167);
case 13:AddVehicleComponent(vehicleid,1176);
case 14:AddVehicleComponent(vehicleid,1180);
case 15:AddVehicleComponent(vehicleid,1187);
case 16:AddVehicleComponent(vehicleid,1184);
case 17:AddVehicleComponent(vehicleid,1109);
case 18:AddVehicleComponent(vehicleid,1192);
case 19:AddVehicleComponent(vehicleid,1177);
case 20:AddVehicleComponent(vehicleid,1178);
case 21:AddVehicleComponent(vehicleid,1186);
case 22:AddVehicleComponent(vehicleid,1183);
case 23:AddVehicleComponent(vehicleid,1110);
case 24:AddVehicleComponent(vehicleid,1193);
}



//ROOF VENT
new rdn05 = random(16);
switch(rdn05)
{
case 0:AddVehicleComponent(vehicleid,1035);
case 1:AddVehicleComponent(vehicleid,1054);
case 2:AddVehicleComponent(vehicleid,1067);
case 3:AddVehicleComponent(vehicleid,1055);
case 4:AddVehicleComponent(vehicleid,1032);
case 5:AddVehicleComponent(vehicleid,1088);
case 6:AddVehicleComponent(vehicleid,1035);
case 7:AddVehicleComponent(vehicleid,1053);
case 8:AddVehicleComponent(vehicleid,1068);
case 9:AddVehicleComponent(vehicleid,1061);
case 10:AddVehicleComponent(vehicleid,1033);
case 11:AddVehicleComponent(vehicleid,1091);
case 12:AddVehicleComponent(vehicleid,1130);
case 13:AddVehicleComponent(vehicleid,1128);
case 14:AddVehicleComponent(vehicleid,1131);
case 15:AddVehicleComponent(vehicleid,1103);
}


//SPOILERS
new rdn06 = random(12);
switch(rdn06)
{
case 0:AddVehicleComponent(vehicleid,1147);
case 1:AddVehicleComponent(vehicleid,1049);
case 2:AddVehicleComponent(vehicleid,1162);
case 3:AddVehicleComponent(vehicleid,1158);
case 4:AddVehicleComponent(vehicleid,1138);
case 5:AddVehicleComponent(vehicleid,1164);
case 6:AddVehicleComponent(vehicleid,1146);
case 7:AddVehicleComponent(vehicleid,1150);
case 8:AddVehicleComponent(vehicleid,1158);
case 9:AddVehicleComponent(vehicleid,1060);
case 10:AddVehicleComponent(vehicleid,1139);
case 11:AddVehicleComponent(vehicleid,1163);
}



//SAIAS
new rdn07 = random(20);
switch(rdn07)
{
case 0:{
AddVehicleComponent(vehicleid,1036);
AddVehicleComponent(vehicleid,1040);}
case 1:{
AddVehicleComponent(vehicleid,1047);
AddVehicleComponent(vehicleid,1051);}
case 2:{
AddVehicleComponent(vehicleid,1069);
AddVehicleComponent(vehicleid,1071);}
case 3:{
AddVehicleComponent(vehicleid,1056);
AddVehicleComponent(vehicleid,1062);}
case 4:{
AddVehicleComponent(vehicleid,1026);
AddVehicleComponent(vehicleid,1027);}
case 5:{
AddVehicleComponent(vehicleid,1090);
AddVehicleComponent(vehicleid,1094);}
case 6:{
AddVehicleComponent(vehicleid,1039);
AddVehicleComponent(vehicleid,1041);}
case 7:{
AddVehicleComponent(vehicleid,1048);
AddVehicleComponent(vehicleid,1052);}
case 8:{
AddVehicleComponent(vehicleid,1070);
AddVehicleComponent(vehicleid,1072);}
case 9:{
AddVehicleComponent(vehicleid,1057);
AddVehicleComponent(vehicleid,1063);}
case 10:{
AddVehicleComponent(vehicleid,1031);
AddVehicleComponent(vehicleid,1030);}
case 11:{
AddVehicleComponent(vehicleid,1093);
AddVehicleComponent(vehicleid,1095);}
case 12:{
AddVehicleComponent(vehicleid,1042);
AddVehicleComponent(vehicleid,1099);}
case 13:{
AddVehicleComponent(vehicleid,1102);
AddVehicleComponent(vehicleid,1133);}
case 14:{
AddVehicleComponent(vehicleid,1134);
AddVehicleComponent(vehicleid,1137);}
case 15:{
AddVehicleComponent(vehicleid,1108);
AddVehicleComponent(vehicleid,1107);}
case 16:{
AddVehicleComponent(vehicleid,1122);
AddVehicleComponent(vehicleid,1101);}
case 17:{
AddVehicleComponent(vehicleid,1106);
AddVehicleComponent(vehicleid,1124);}
case 18:{
AddVehicleComponent(vehicleid,1118);
AddVehicleComponent(vehicleid,1120);}
case 19:{
AddVehicleComponent(vehicleid,1119);
AddVehicleComponent(vehicleid,1121);}
}

//BULLBARS
new rdn08 = random(14);
switch(rdn08)
{
case 0:AddVehicleComponent(vehicleid,1100);
case 1:AddVehicleComponent(vehicleid,1123);
case 2:AddVehicleComponent(vehicleid,1125);
case 3:AddVehicleComponent(vehicleid,1117);
case 4:AddVehicleComponent(vehicleid,1025);
case 5:AddVehicleComponent(vehicleid,1074);
case 6:AddVehicleComponent(vehicleid,1076);
case 7:AddVehicleComponent(vehicleid,1078);
case 8:AddVehicleComponent(vehicleid,1081);
case 9:AddVehicleComponent(vehicleid,1082);
case 10:AddVehicleComponent(vehicleid,1085);
case 11:AddVehicleComponent(vehicleid,1096);
case 12:AddVehicleComponent(vehicleid,1097);
case 13:AddVehicleComponent(vehicleid,1098);
}

new rdn09 = random(13);
switch(rdn09)
{
case 0:AddVehicleComponent(vehicleid, 1073);
case 1:AddVehicleComponent(vehicleid, 1074);
case 2:AddVehicleComponent(vehicleid, 1075);
case 3:AddVehicleComponent(vehicleid, 1076);
case 4:AddVehicleComponent(vehicleid, 1077);
case 5:AddVehicleComponent(vehicleid, 1078);
case 6:AddVehicleComponent(vehicleid, 1079);
case 7:AddVehicleComponent(vehicleid, 1080);
case 8:AddVehicleComponent(vehicleid, 1081);
case 9:AddVehicleComponent(vehicleid, 1082);
case 10:AddVehicleComponent(vehicleid, 1083);
case 11:AddVehicleComponent(vehicleid, 1084);
case 12:AddVehicleComponent(vehicleid, 1085);
}

//HYDRAULICA E NITRO
AddVehicleComponent(vehicleid, 1086);
AddVehicleComponent(vehicleid, 1087);



return 1;
}

AntiDeAMX()
{
    new a[][] =
    {
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}

stock LoadConfig()
{
SvFullValue = dini_Int("ZNS.ini","SVFullValue");
SvFullValueMinutes = dini_Int("ZNS.ini","SvFullValueMinutes");
if(SvFullValue == 0) SvFullValue = MAX_PLAYERS;
if(SvFullValueMinutes == 0) SvFullValue = 5;
format(ABanNick, sizeof(ABanNick), "%s", dini_Get("ZNS.ini","abannick")); //Nick do /ABAN
SetGranaFacil(dini_Int("ZNS.ini","granafacil")); //Valor do Grana Fácil
MensagemADMAtivado = dini_Int("ZNS.ini","admmsgs"); //Mensagens para os ADM: /ADM
new sdstring[60];format(sdstring, sizeof(sdstring), "hostname %s", dini_Get("ZNS.ini","svname"));SendRconCommand(sdstring); //Hostname
TextDrawSetString(TxDNotificador, dini_Get("ZNS.ini","notificar"));//TextDraw Notificar
SetWeather(dini_Int("ZNS.ini","clima"));//Clima do servidor
AutoCiclo = dini_Int("ZNS.ini","autociclo");//Auto ciclo dia e noite real do servidor
if(AutoCiclo == 0){SetWorldTime(dini_Int("ZNS.ini","horario"));}//Horário do servidor
if(dini_Int("ZNS.ini","HydraGM")){CriarHydraGM();} //HYDRA
if(dini_Int("ZNS.ini","SeaspGM")){CriarSeaspGM();} //SEASPARROW
return 1;
}

stock SaveConfig()
{
}

stock HexToInt(string[])
{
	new i = 0;
	new cur = 1;
	new res = 0;
	for (i = strlen(string); i > 0; i--)
	{
		if (string[i-1] < 58) res = res + cur*(string[i-1] - 48); else res = res + cur*(string[i-1] - 65 + 10);
	    cur = cur*16;
	}
	return res;
}

forward GetPlayerFPS(playerid);
public GetPlayerFPS(playerid)
{
return pFPS[playerid];
}


stock ProcessarArenaKillSpree(playerid,killerid)
{
    KillSpree[playerid] = 0;
	if(GetPlayerVirtualWorld(killerid) > 0)
	{
	KillSpree[killerid]++;
	if(KillSpree[playerid] == 0)
	{
	KillTimer(TimerKillSpree[playerid]);
	}
	if(KillSpree[killerid] == 1)
	{
	TimerKillSpree[killerid] = SetTimerEx("StopKillSpree", 10000, false, "i", killerid);
	}
	if(KillSpree[killerid] == 2)
	{
	KillTimer(TimerKillSpree[killerid]);
	new String[128]; format(String, sizeof(String), "KillSpree: %s (id:%d) matou 2 seguidos. (Double Kill)", PlayerNick(killerid), killerid);
	SendMessageMesmoWorld(killerid, Cor_DoubleKill, String);
	GameTextForPlayer(killerid,"~n~~n~~n~~n~~n~~n~~y~Double Kill", 5000, 5);
	TimerKillSpree[killerid] = SetTimerEx("StopKillSpree", 10000, false, "i", killerid);
	}
	if(KillSpree[killerid] == 3)
	{
	KillTimer(TimerKillSpree[killerid]);
	new String[128]; format(String, sizeof(String), "KillSpree: %s (id:%d) matou 3 seguidos. (Multi Kill)", PlayerNick(killerid), killerid);
	SendMessageMesmoWorld(killerid, Cor_MultiKill, String);
	GameTextForPlayer(killerid,"~n~~n~~n~~n~~n~~n~~r~Multi Kill", 5000, 5);
	TimerKillSpree[killerid] = SetTimerEx("StopKillSpree", 10000, false, "i", killerid);
	}
	if(KillSpree[killerid] == 4)
	{
	KillTimer(TimerKillSpree[killerid]);
	new String[128]; format(String, sizeof(String), "KillSpree: %s (id:%d) matou 4 seguidos. (Ultra Kill)", PlayerNick(killerid), killerid);
	SendMessageMesmoWorld(killerid, Cor_UltraKill, String);
	GameTextForPlayer(killerid,"~n~~n~~n~~n~~n~~n~~r~Ultra Kill", 5000, 5);
	TimerKillSpree[killerid] = SetTimerEx("StopKillSpree", 10000, false, "i", killerid);
	}
	if(KillSpree[killerid] == 5)
	{
	KillTimer(TimerKillSpree[killerid]);
	new String[128]; format(String, sizeof(String), "KillSpree: %s (id:%d) matou 5 seguidos. (Fantastic)", PlayerNick(killerid), killerid);
	SendMessageMesmoWorld(killerid, Cor_Fantastic, String);
	GameTextForPlayer(killerid,"~n~~n~~n~~n~~n~~n~~r~Fantastic", 5000, 5);
    TimerKillSpree[killerid] = SetTimerEx("StopKillSpree", 10000, false, "i", killerid);
	}
	if(KillSpree[killerid] == 6)
	{
	KillTimer(TimerKillSpree[killerid]);
	new String[128]; format(String, sizeof(String), "KillSpree: %s (id:%d) matou 6 seguidos. (Unbelievable)", PlayerNick(killerid), killerid);
	SendMessageMesmoWorld(killerid, Cor_Unbelievable, String);
	GameTextForPlayer(killerid,"~n~~n~~n~~n~~n~~n~~r~Unbelievable", 5000, 5);
	TimerKillSpree[killerid] = SetTimerEx("StopKillSpree", 10000, false, "i", killerid);
	}
	if(KillSpree[killerid] >= 7)
	{
	KillTimer(TimerKillSpree[killerid]);
	new String[128]; format(String, sizeof(String), "KillSpree: %s (id:%d) matou %d seguidos. (Very Unbelievable)", PlayerNick(killerid), killerid, KillSpree[killerid]);
	SendMessageMesmoWorld(killerid, Cor_VeryUnbelievable, String);
    GameTextForPlayer(killerid,"~n~~n~~n~~n~~n~~n~~r~Very Unbelievable", 5000, 5);
	TimerKillSpree[killerid] = SetTimerEx("StopKillSpree", 10000, false, "i", killerid);
	}
	}
	return 1;
}

forward StopKillSpree(playerid);
public StopKillSpree(playerid)
{
    KillSpree[playerid] = 0;
    return 1;
}

forward SendMessageMesmoWorld(playerid, color, const string[]);
public SendMessageMesmoWorld(playerid, color, const string[])
{
 for(new i; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i)) if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid)) SendClientMessage(i, color, string);
	}
	return 1;
}

stock PlayerNick(playerid)
{
	new Nick[MAX_PLAYER_NAME+1];
	GetPlayerName(playerid, Nick, sizeof(Nick));
	return Nick;
}

stock LifeBaixo(playerid)
{
new Float:HP;
GetPlayerHealth(playerid, HP);
if(HP < 50) return 1;
return 0;
}

stock GetWeaponIDFromName(WeaponName[])
{
	if(strfind("molotov",WeaponName,true)!=-1) return 18;
	for(new i = 0; i <= 46; i++)
	{
		switch(i)
		{
			case 0,19,20,21,44,45: continue;
			default:
			{
				new name[32]; GetWeaponName(i,name,32);
				if(strfind(name,WeaponName,true) != -1) return i;
			}
		}
	}
	return -1;
}

stock IsValidWeapon(weaponid)
{
    if (weaponid > 0 && weaponid < 19 || weaponid > 21 && weaponid < 47) return 1;
    return 0;
}

GetVehicleModelIDFromName(vname[])
{
	for(new i = 0; i < 211; i++)
	{
		if ( strfind(VehicleNames[i], vname, true) != -1 )
			return i + 400;
	}
	return -1;
}


stock MalaAberta(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if(boot == 0) return 1; else return 0;
}

stock CapoAberto(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if(bonnet == 0) return 1; else return 0;
}

stock PortasAbertas(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if(doors == 0) return 1; else return 0;
}

stock AlarmeLigado(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if(alarm == 0) return 1; else return 0;
}

stock FaroisLigados(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if(lights == 0) return 1; else return 0;
}

stock MotorLigado(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if(engine == 0) return 1; else return 0;
}

stock MalaAbrir(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, 1, objective);
}

stock MalaFechar(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, 0, objective);
}

stock CapoAbrir(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, 1, boot, objective);
}

stock CapoFechar(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, 0, boot, objective);
}

stock PortasAbrir(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, engine, lights, alarm, 1, bonnet, boot, objective);
}

stock PortasFechar(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, engine, lights, alarm, 0, bonnet, boot, objective);
}

stock AlarmeLigar(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, engine, lights, 1, doors, bonnet, boot, objective);
}

stock AlarmeDesligar(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, engine, lights, 0, doors, bonnet, boot, objective);
}

stock FaroisLigar(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, engine, 1, alarm, doors, bonnet, boot, objective);
}

stock FaroisDesligar(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, engine, 0, alarm, doors, bonnet, boot, objective);
}

stock MotorLigar(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, 1, lights, alarm, doors, bonnet, boot, objective);
}

stock MotorDesligar(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);
}

stock IsABike(vehicleid) //Made by me :D
{
        new result;
        new model = GetVehicleModel(vehicleid);
    switch(model)
    {
        case 509, 481, 510, 462, 448, 581, 522, 461, 521, 523, 463, 586, 468, 471: result = model;
        default: result = 0;
    }
        return result;
}

stock IsACombatVehicle(vehicleid)
{
        new result;
        new model = GetVehicleModel(vehicleid);
    switch(model)
    {
        case 447, 425, 520, 476, 432: result = model;
        default: result = 0;
    }
        return result;
}


stock ChecarAntiFlood(playerid)
{
new Segundos = TickCounter-AF_UltimoComando[playerid];
if(Segundos < 5){return true;}else{return false;}
}

stock ProgramarAntiFlood(playerid)
{
AF_UltimoComando[playerid] = TickCounter;
return true;
}

stock AntiFloodMsg(playerid)
{
SendClientMessage(playerid, COLOUR_AVISO,"[AVISO]: Comando protegido por anti-flood, aguarde alguns segundos e tente novamente");
return 1;
}

stock Nome(playerid)
{
	new pname[24];
	GetPlayerName(playerid, pname, 24);
	return pname;
}

stock ContaExiste(playerid)
{
new String[300];
	format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
	return DOF2_FileExists(String);
}

stock IdGang(playerid)
{
	new StringNome[100];
    format(StringNome, sizeof(StringNome), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
    return StringNome;
}

stock ArquivoGangInt(playerid, linha[])
{
 	new str[100];
	format(str, sizeof(str), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Membro]);
	return DOF2_GetInt(str, linha);
}

stock ArquivoGangHex(playerid, linha[])
{
 	new str[100];
	format(str, sizeof(str), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Membro]);
	return DOF2_GetHex(str, linha);
}

stock AvisoLider(playerid, mensagem[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(PlayerDados[i][Membro] == PlayerDados[playerid][Lider] || PlayerDados[i][Lider] == PlayerDados[playerid][Lider])
	    {
	    	SendClientMessage(i, COLOUR_DICA, mensagem);
		}
	}
	return 1;
}

stock DialogGang(playerid)
{
new String[300];
    format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
	format(String, sizeof(String), "{0DD0DE}Menu do Cla %s", DOF2_GetString(String, "Nome"));
	ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_LIST, String,"{FFFFFF}Nome do Cla\n{FFFFFF}Skin do Cla\n{FFFFFF}Convidar\n{FFFFFF}Promover\n{FFFFFF}Spawn\n{FFFFFF}Cor\n{FF0000}Demitir\n{FF0000}Encerrar Cla", "Ver", "Cancelar");
	return 1;
}

stock SalvarDados(playerid)
{
    new String[300];
    format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
	DOF2_SetInt(String, "Lider", PlayerDados[playerid][Lider]);
	DOF2_SetInt(String, "Membro", PlayerDados[playerid][Membro]);
	DOF2_SetInt(String, "Cargo", PlayerDados[playerid][Cargo]);
	return 1;
}

stock SetarCor(playerid, corg, mensagem[])
{
    new String[300];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(PlayerDados[i][Membro] == PlayerDados[playerid][Lider])
	    {
	        cor[i] = corg;
	        SetPlayerColor(i, corg);
	        SendClientMessage(i, corg, mensagem);
		}
	}
	format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", GangPlayer(playerid));
	DOF2_SetHex(String, "CorG", corg);
	DOF2_SaveFile();
	return 1;
}

stock SetarCorHmc(playerid, corg)
{
    new String[300];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(PlayerDados[i][Membro] == PlayerDados[playerid][Lider])
	    {
	        SetPlayerColor(i, corg);
		}
	}
	format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", GangPlayer(playerid));
	DOF2_SetHex(String, "CorG", corg);
	DOF2_SaveFile();
	return 1;
}

stock GangPlayer(playerid)
{
	new str[128];
	format(str, sizeof(str), "LAGANGS/Players/%s.ini", Nome(playerid));
	return DOF2_GetInt(str, "Membro");
}

stock NomeDoPlayer(playerid)
{
new N[MAX_PLAYER_NAME];
GetPlayerName(playerid, N, sizeof(N));
return N;
}

forward NotificarTeleporte(playerid,local[]);
public NotificarTeleporte(playerid,local[])
{
new pname[MAX_PLAYER_NAME],string[128];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "{FF387A}%s {B5B5B5}foi para %s", pname, local);
SendClientMessageToAll(COLOUR_TELEPORTE, string);
return 1;
}

forward LimparTela3();
public LimparTela3()
{
TextDrawHideForAll(TxDTela3);
TextDrawSetString((TxDTela3)," ");
TimerTELA3 = 0;
Tela3Displaying = false;
return 1;
}

stock ModifyVehicleSpeed(vehicleid,mph) //Miles Per Hour
{
	new Float:Vx,Float:Vy,Float:Vz,Float:DV,Float:multiple;
	GetVehicleVelocity(vehicleid,Vx,Vy,Vz);
	DV = floatsqroot(Vx*Vx + Vy*Vy + Vz*Vz);
	if(DV > 0) //Directional velocity must be greater than 0 (display strobes if 0)
	{
		multiple = ((mph + DV * 100) / (DV * 100)); //Multiplying DV by 100 calculates speed in MPH
		return SetVehicleVelocity(vehicleid,Vx*multiple,Vy*multiple,Vz*multiple);
	}
	return 0;
}


stock ShowGranaFacilLucros(playerid)
{
new string2[128];
format(string2, sizeof(string2), "{C0C0C0}[LUCROS]: Um segundo $%i | Um minuto = $%i | Dez minutos = $%i | Uma hora = $%i", GranaFacilValor, GranaFacilValor*60,GranaFacilValor*600,GranaFacilValor*3600);
SendClientMessage(playerid, COLOUR_INFORMACAO, string2);
return 1;
}

stock StringTXTBugado(string[])
{
new tils;
for(new i; i < strlen(string); i++)
if(string[i] == '~') tils++;
return tils % 2;
}

stock gerarString(string[], size = sizeof(string))
{
	for(new i = 0; i != size; ++i)
	{
		string[ i ] = ((random(0x5A - 0x41) + 0x41) + (random(2) * 0x20));
	}
	return string;
}

stock IsAColorHackText(text[])
{
new bool:state1,bool:state2;
if(strfind(text, "{", false) != -1) state1 = true; else state1 = false;
if(strfind(text, "}", false) != -1) state2 = true; else state2 = false;
if(state1 == true && state2 == true) return 1;
return 0;
}

GPS_Update(playerid,rastreado);
public GPS_Update(playerid,rastreado){
	if(IsPlayerConnected(rastreado)){
		new Gname[MAX_PLAYER_NAME];
		new StringGPS1[128],StringGPS2[128];
		GetPlayerName(rastreado, Gname, sizeof(Gname));
		new Float:Distancia = GetDistanceBetweenPlayers(playerid, rastreado);
		format(StringGPS1, sizeof(StringGPS1), "~b~~h~~h~Nick~w~: ~b~~h~~h~%s ~w~- ~y~ID~w~: ~y~%d ~w~- ~p~~h~Distancia~w~: ~p~~h~%0.0f metro(s).", Gname, rastreado, Distancia);
		format(StringGPS2, sizeof(StringGPS2), "~g~~h~~h~Cidade~w~: ~g~~h~~h~%s ~w~- ~r~~h~Local~w~: ~r~~h~%s.", GetPlayerArea1(rastreado), GetPlayerArea(rastreado));
		if(GetPlayerInterior(rastreado) >= 1) {format(StringGPS2, sizeof(StringGPS2), "~r~~h~PLAYER EM INTERIOR");format(StringGPS1, sizeof(StringGPS1), "~y~AVISO: ~w~%s nao pode ser localizado",Gname);}
		if(GetPlayerVirtualWorld(rastreado) >= 1) {format(StringGPS2, sizeof(StringGPS2), "~r~~h~PLAYER EM OUTRA DIMENSAO");format(StringGPS1, sizeof(StringGPS1), "~y~AVISO: ~w~%s nao pode ser localizado",Gname);}
		if(!IsPlayerSpawned(rastreado)) {format(StringGPS2, sizeof(StringGPS2), "~r~~h~PLAYER EM OUTRA DIMENSAO");format(StringGPS1, sizeof(StringGPS1), "~y~AVISO: ~w~%s nao pode ser localizado",Gname);}
		if(AGps[rastreado] == true) {format(StringGPS2, sizeof(StringGPS2), "~r~~h~PLAYER COM ANTI-GPS");format(StringGPS1, sizeof(StringGPS1), "~y~AVISO: ~w~%s nao pode ser localizado",Gname);}
		if( playerid == rastreado) format(StringGPS1, sizeof(StringGPS1), "~g~~h~~h~GPS LIGADO EM VOCE MESMO - ~w~SUA LOCALIZACAO:", Gname, rastreado, Distancia);
		TextDrawSetString(Text:TextGPS1[playerid], StringGPS1);
		TextDrawSetString(Text:TextGPS2[playerid], StringGPS2);
	}else{
		PararGPS(playerid);
		SendClientMessage(playerid, COLOUR_AVISO, "[AVISO]: O Sistema de GPS foi desligado (Player desconectou)");
	}
	return 1;
}

forward COLOR_Update(playerid, rastreado);
public COLOR_Update(playerid, rastreado){
	if(AGps[rastreado] != true)	{
		if(Piscando[playerid] == false) {
			SetPlayerMarkerForPlayer(playerid, rastreado, COLOUR_ERRO); Piscando[playerid] = true;
		}else{
			SetPlayerMarkerForPlayer(playerid, rastreado, COLOUR_INFORMACAO); Piscando[playerid] = false;
		}
	}
	return 1;
}

forward FindIpPattern(playerid,const string[]);
public FindIpPattern(playerid,const string[])
{
	new stringNumeric=false;
	new stringBegin;
	new ipDigits=0;
	for(new i=0; i<strlen(string); i++)
	{
	    if(string[i]<='9' && string[i]>='0')
	    {
	        if(!stringNumeric) // first digit
	        {
	            stringNumeric=true;
	            stringBegin=i;
		 	    if(i==strlen(string)-1) // string ends with one digit number
		 	    {
			        ipDigits++;
			        if(ipDigits>3) // 4 digits
			            return 1;
		 	    }
	        }
	        else
		 	{
		 	    if(i==strlen(string)-1) // string ends with the last digit
		 	    {
	           		new stringn[256];
    	       		new number;
					for(new j=stringBegin; j<i+1; j++)
					    stringn[j-stringBegin]=string[j];
			        stringn[i-stringBegin+1]=0;
			        number=strval(stringn);
				    if(number>=0 && number<256) // our case
				    {
				        ipDigits++;
				        if(ipDigits>3) // 4 digits
				            return 1;
				    }
		 	    }
		 	}
	    }
	    else
	    {
	        if(stringNumeric) // last digit+1
	        {
	            stringNumeric=false;
           		new stringn[256];
           		new number;
				for(new j=stringBegin; j<i; j++)
				    stringn[j-stringBegin]=string[j];
		        stringn[i-stringBegin]=0;
		        number=strval(stringn);
			    if(number>=0 && number<256) // our case
			    {
			        ipDigits++;
			        if(ipDigits>3) // 4 digits
			            return 1;
			    }
			    else // not in ip-group range
			        ipDigits=0; // reset ip digit counter;
	        }
	    }
	}
	return 0;
}

dcmd_verlog(playerid,params[])
{
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,StringTable[8]);
if(!strlen(params)) return SendClientMessage(playerid,COLOUR_ERRO,"USO: /verlog [log] - Para obter a lista de logs: /verlog lista");
new PlayerLevel = CallRemoteFunction("GetPlayerAdminLevel","i",playerid);
if(IsPlayerAdmin(playerid) && PlayerLevel >= 7)
{
if(strcmp(params, "setpass", true) == 0) return 			ExibirLog(playerid, "ladmin/logs/PasswordChangesSetPass.txt");
if(strcmp(params, "alg", true) == 0) return 				ExibirLog(playerid, "ladmin/logs/ADMLogins.txt");
}
if(PlayerLevel >= 7)
{
if(strcmp(params, "loginsrcon", true) == 0) return 			ExibirLog(playerid, "ladmin/logs/RCONLogins.txt");
if(strcmp(params, "objetos", true) == 0) return 			ExibirLog(playerid, "ladmin/logs/Objects.txt");
if(strcmp(params, "pickups", true) == 0) return 			ExibirLog(playerid, "ladmin/logs/Pickups.txt");
if(strcmp(params, "rmadm", true) == 0) return 				ExibirLog(playerid, "ladmin/logs/RMADM.txt");
}
if(PlayerLevel >= 4)
{
if(strcmp(params, "novosadmins", true) == 0) return		 	ExibirLog(playerid, "ladmin/logs/AdminLog.txt");
if(strcmp(params, "contasdeletadas", true) == 0) return		ExibirLog(playerid, "ladmin/logs/DeletedAccs.txt");
if(strcmp(params, "tempadm", true) == 0) return 			ExibirLog(playerid, "ladmin/logs/TempAdminLog.txt");
if(strcmp(params, "nickstrocadosadm", true) == 0) return 	ExibirLog(playerid, "ladmin/logs/NicksTrocadosADM.txt");
if(strcmp(params, "senhastrocadas", true) == 0) return 		ExibirLog(playerid, "ladmin/logs/PasswordChanges.txt");
if(strcmp(params, "accrb", true) == 0) return 				ExibirLog(playerid, "ladmin/logs/accrb.txt");
}
if(PlayerLevel >= 3)
{
if(strcmp(params, "carros", true) == 0) return 				ExibirLog(playerid, "ladmin/logs/CarSpawns.txt");
if(strcmp(params, "aka", true) == 0) return 				ExibirLog(playerid, "ladmin/config/aka.txt");
if(strcmp(params, "BanLIP", true) == 0) return 				ExibirLog(playerid, "ladmin/logs/BanLIP.txt");
}
if(PlayerLevel >= 2)
{
if(strcmp(params, "loginsilegais", true) == 0) return 		ExibirLog(playerid, "ladmin/logs/IllegalNickLogins.txt");
if(strcmp(params, "contasbanidas", true) == 0) return		ExibirLog(playerid, "ladmin/logs/BannedAccs.txt");
if(strcmp(params, "desbanidos", true) == 0) return 			ExibirLog(playerid, "ladmin/logs/UnbannedAccs.txt");
}
if(PlayerLevel >= 1)
{
if(strcmp(params, "banidos", true) == 0) return 			ExibirLog(playerid, "ladmin/logs/BanLog.txt");
if(strcmp(params, "lstart", true) == 0) return 				ExibirLog(playerid, "ladmin/logs/InicioFim.txt");
if(strcmp(params, "kickados", true) == 0) return 			ExibirLog(playerid, "ladmin/logs/KickLog.txt");
if(strcmp(params, "nickstrocados", true) == 0) return 		ExibirLog(playerid, "ladmin/logs/NicksTrocados.txt");
if(strcmp(params, "reports", true) == 0) return 			ExibirLog(playerid, "ladmin/logs/ReportLog.txt");
if(strcmp(params, "ipsdesbanidos", true) == 0) return 		ExibirLog(playerid, "ladmin/logs/UnbannedIPs.txt");
if(strcmp(params, "missoes", true) == 0) return 			ExibirLog(playerid, "ladmin/logs/Missoes.txt");
if(strcmp(params, "x1p", true) == 0) return 				ExibirLog(playerid, "ladmin/logs/X1.txt");
if(strcmp(params, "x1wp", true) == 0) return 				ExibirLog(playerid, "ladmin/logs/X1W.txt");
if(strcmp(params, "punidosrq", true) == 0) return 			ExibirLog(playerid, "ladmin/logs/PunidosRQ.txt");
if(strcmp(params, "abusosscore", true) == 0) return 		ExibirLog(playerid, "ladmin/logs/AbusosScore.txt");
if(strcmp(params, "missoeshack", true) == 0) return 		ExibirLog(playerid, "ladmin/logs/MissoesHack.txt");
if(strcmp(params, "bfl", true) == 0) return 				ExibirLog(playerid, "ladmin/logs/BotFlood.txt");
}
//
if(strcmp(params, "lista", true) == 0)
{
SendClientMessage(playerid, COLOUR_INFORMACAO,"===================================================================");
SendClientMessage(playerid, COLOUR_AVISO,"Lista de Logs para serem usadas através do: /verlog <log>");
SendClientMessage(playerid, COLOUR_AVISO," ");
SendClientMessage(playerid, COLOUR_BRANCO,"missoeshack abusosscore punidosrq x1wp x1p missoes ipsdesbanidos, bfl");
SendClientMessage(playerid, COLOUR_BRANCO,"reports nickstrocados kickados lstart banidos desbanidos contasbanidas");
SendClientMessage(playerid, COLOUR_BRANCO,"loginsilegais aka carros senhastrocadas nickstrocadosadm tempadm");
SendClientMessage(playerid, COLOUR_BRANCO,"contasdeletadas novosadmins rmadm pickups objetos loginsrcon setpass");
SendClientMessage(playerid, COLOUR_BRANCO,"accrb alg banlip");
SendClientMessage(playerid, COLOUR_INFORMACAO,"===================================================================");
return 1;
}
SendClientMessage(playerid, COLOUR_ERRO,"[ERRO]: O arquivo de log é inválido ou você não ter permissão para visualizar");
return 1;
}

stock ExibirLog(playerid, log[], lines = 5, bool:checksize = true)
{
new str[128];
if(ShowLogLines[playerid] > 0) lines = ShowLogLines[playerid];
if(ShowLogLines[playerid] > 100) ShowLogLines[playerid] = 100;
if(!fexist(log)){
format(str, sizeof(str), "[LOG]: O arquivo não existe: {C0C0C0}%s", log);
SendClientMessage(playerid,0xFF0000FF,str);
return 1;}
new Buffer[150],TotalLines,Lines;
new File:LogFile = fopen(log, io_read);
if(checksize == true)
{
	if(flength(LogFile) > 512000) //500KB
	{
	fclose(LogFile);
	SendClientMessage(playerid,0xFF,"[ERRO]: O arquivo de log não pode ser exibido por passar do tamanho limite (500KB)");
	return 1;
	}
}
while(fread(LogFile, Buffer)) TotalLines++;
fseek(LogFile, seek_start);
format(str, sizeof(str), "[LOG]: Lendo as últimas %i linhas do arquivo: {C0C0C0}%s", lines, log);
SendClientMessage(playerid,0x00FF00FF,str);
	while(fread(LogFile, Buffer))
	{
	Lines++;
	if(TotalLines - Lines < lines) SendClientMessage(playerid,0xFFFFFFFF,Buffer);
	}
SendClientMessage(playerid,0x00FF00FF,"[LOG]: Leitura efetuada com sucesso!");
fclose(LogFile);
return 1;
}

stock GetTotalLifeInt(playerid)
{
new Float:life, Float:colete, Float:totallife;
GetPlayerHealth(playerid, Float:life);
GetPlayerArmour(playerid, Float:colete);
totallife = life + colete;
return floatround(totallife);
}

stock PlayerIp(playerid)
{
new ip[16];
GetPlayerIp(playerid, ip, sizeof(ip));
return ip;
}

stock GetPlayerNameEx(playerid)
{
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
return pname;
}

stock OrganizarVeiculos()
{
for(new v; v<UltimoVeiculoGM; v++)
if(GetVehicleDriver(v) == -1){
SetVehicleToRespawn(v);}
}

//XENON
IsPlayerOnBike(playerid){
	if(IsPlayerInAnyVehicle(playerid)){
		new vehicleclass = GetVehicleModel(GetPlayerVehicleID(playerid));
		switch(vehicleclass){
			case 448:return 1;
			case 461:return 1;
			case 462:return 1;
			case 463:return 1;
			case 468:return 1;
			case 521:return 1;
			case 522:return 1;
			case 523:return 1;
			case 581:return 1;
			case 586:return 1;
			case 471:return 1;
		}
	}
return 0;
}

//BOATS
IsPlayerInBoat(playerid){
	if(IsPlayerInAnyVehicle(playerid)){
		new vehicleclass = GetVehicleModel(GetPlayerVehicleID(playerid));
		switch(vehicleclass){
			case 430:return 1;
			case 446:return 1;
			case 452:return 1;
			case 453:return 1;
			case 454:return 1;
			case 472:return 1;
			case 473:return 1;
			case 484:return 1;
			case 493:return 1;
			case 595:return 1;
		}
	}
return 0;
}

//BICYCLES
IsPlayerOnBicycle(playerid){
	if(IsPlayerInAnyVehicle(playerid)){
		new vehicleclass = GetVehicleModel(GetPlayerVehicleID(playerid));
		switch(vehicleclass){
			case 481:return 1;
			case 509:return 1;
			case 510:return 1;
		}
	}
return 0;
}

//HELICOPTERS
IsPlayerOnHeli(playerid){
	if(IsPlayerInAnyVehicle(playerid)){
		new vehicleclass = GetVehicleModel(GetPlayerVehicleID(playerid));
		switch(vehicleclass){
			case 417:return 1;
			case 425:return 1;
			case 447:return 1;
			case 469:return 1;
			case 487:return 1;
			case 488:return 1;
			case 497:return 1;
			case 548:return 1;
			case 563:return 1;
		}
	}
return 0;
}
//PLANES
IsPlayerOnPlane(playerid){
	if(IsPlayerInAnyVehicle(playerid)){
		new vehicleclass = GetVehicleModel(GetPlayerVehicleID(playerid));
		switch(vehicleclass){
			case 460:return 1;
			case 476:return 1;
			case 511:return 1;
			case 512:return 1;
			case 519:return 1;
			case 520:return 1;
			case 553:return 1;
			case 577:return 1;
			case 592:return 1;
			case 593:return 1;
			case 509:return 1;
		}
	}
return 0;
}

//RC VEHICLES
IsPlayerOnRC(playerid){
	if(IsPlayerInAnyVehicle(playerid)){
		new vehicleclass = GetVehicleModel(GetPlayerVehicleID(playerid));
		switch(vehicleclass){
			case 464:return 1;
			case 465:return 1;
			case 441:return 1;
			case 501:return 1;
			case 564:return 1;
			case 594:return 1;
		}
	}
return 0;
}

Nitro(vehicleid){
	new nos = GetVehicleModel(vehicleid);
	switch(nos) {
		case 444:
		return 0;
		case 581:
		return 0;
		case 586:
		return 0;
		case 481:
		return 0;
		case 509:
		return 0;
		case 446:
		return 0;
		case 556:
		return 0;
		case 443:
		return 0;
		case 452:
		return 0;
		case 453:
		return 0;
		case 454:
		return 0;
		case 472:
		return 0;
		case 473:
		return 0;
		case 484:
		return 0;
		case 493:
		return 0;
		case 595:
		return 0;
		case 462:
		return 0;
		case 463:
		return 0;
		case 468:
		return 0;
		case 521:
		return 0;
		case 522:
		return 0;
		case 417:
		return 0;
		case 425:
		return 0;
		case 447:
		return 0;
		case 487:
		return 0;
		case 488:
		return 0;
		case 497:
		return 0;
		case 501:
		return 0;
		case 548:
		return 0;
		case 563:
		return 0;
		case 406:
		return 0;
		case 520:
		return 0;
		case 539:
		return 0;
		case 553:
		return 0;
		case 557:
		return 0;
		case 573:
		return 0;
		case 460:
		return 0;
		case 593:
		return 0;
		case 464:
		return 0;
		case 476:
		return 0;
		case 511:
		return 0;
		case 512:
		return 0;
		case 577:
		return 0;
		case 592:
		return 0;
		case 471:
		return 0;
		case 448:
		return 0;
		case 461:
		return 0;
		case 523:
		return 0;
		case 510:
		return 0;
		case 430:
		return 0;
		case 465:
		return 0;
		case 469:
		return 0;
		case 513:
		return 0;
		case 519:
		return 0;
	}
	return 1;
}
