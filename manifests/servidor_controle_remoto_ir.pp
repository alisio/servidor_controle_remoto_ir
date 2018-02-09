# Classe servidor_controle_remoto_ir
# 
# Descricao:
#   Esta classe instala o servico de controle remoto IR no raspberry Pi, com 
#   raspbian 4.9.59
# Variaveis:
#   $portaDoReceptor   =   porta BCM que recebera o sinal oriundo do receptor IR
#   $portaDoTransmissor   =   porta BCM que enviara o sinal para o transmissor IR

class servidor_controle_remoto_ir (
$portaDoReceptor       =   18,
$portaDoTransmissor    =   22,
$configHardware        = '
LIRCD_ARGS="--uinput"
LOAD_MODULES=true
DRIVER="default"
DEVICE="/dev/lirc0"
MODULES="lirc_rpi"
LIRCD_CONF=""
LIRCMD_CONF=""',

  ){
		$pacotes = ['lirc']
		package {$pacotes:
			ensure 	=> 	'installed',
			allow_virtual 	=> 	'yes',
		}
		file_line {'inserir modulo lirc_dev':
		  ensure             => present,
      path               => '/etc/modules',
      line               => 'lirc_dev',
		}
		file_line { 'inserir modulo das portas lirc ':
		  ensure   =>   present,
		  path   =>   '/etc/modules',
		  line   =>   "lirc_rpi gpio_in_pin=$portaDoReceptor gpio_out_pin=$portaDoTransmissor",
		  match   =>   '^lirc_rpi gpio_in_pin=',
		  append_on_no_match   =>   true,
		}
		file_line { '/boot/config.txt':
		  ensure   =>   present,
		  path   =>   '/boot/config.txt',
		  line   =>   "dtoverlay=lirc-rpi,gpio_in_pin=$portaDoReceptor,gpio_out_pin=$portaDoTransmissor"		  
		}
		file { '/etc/lirc/hardware.conf' :
		  content   =>   $configHardware,
		  ensure    =>   'present',
		  replace   =>   'yes',
		}
		file { '/etc/modprobe.d/ir-remote.conf': 
		  content   =>   "options lirc_rpi gpio_in_pin=$portaDoReceptor gpio_out_pin=$portaDoTransmissor",
		  ensure   =>   'present',
		  replace   =>   'yes',
		}
		
}
include stdlib
include servidor_controle_remoto_ir