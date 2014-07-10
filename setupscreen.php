#!/usr/bin/env php
<?php
if(!isset($argv[1])){
	echo "Unknown command\n";
	exit();
}

/**
 * Class BaseMonitor
 * @author Jonas Falck
 */
class BaseMonitor{/*{{{*/
	protected $state;
	protected $name;
	protected function exec($cmd){
		exec('xrandr --output '.$this->name.' '.$cmd);
	}
}/*}}}*/

/**
 * Class Monitors
 * @author Jonas Falck
 */
class Monitors{/*{{{*/

	private $monitors = array();

	public function __construct(){
		$this->parseXrandr();
	}

	private function parseXrandr(){

		$out = '';
		exec('xrandr',$out);
		foreach($out as $line){
			if(preg_match('/^(.*) (connected|disconnected)/',$line,$tmp) ){
				$monitor = new Monitor($tmp[1]);
				$monitor->setState($tmp['2']);
				$this->monitors[$tmp[1]] = $monitor;
			}
		}
	}

	public function getAll(){
		return $this->monitors;
	}
	public function get($name){
		return $this->monitors[$name];
	}

	public function turnOffAllExcept($name){
		foreach($this->monitors as $monitor){
			if($monitor->getName() === $name)
				continue;
			$monitor->off();
		}
	}
}/*}}}*/

/**
 * Class Monitor
 * @author Jonas Falck
 */
class Monitor extends BaseMonitor{/*{{{*/
	public function __construct($name){
		$this->name = $name;
	}
	/*
	 * Getter for name
	 */
	public function getName(){
		return $this->name;
	}

	public function setState($state){
		$this->state = $state;
		return $this;
	}
	public function off(){
		$this->exec('--off');
		return $this;
	}
	public function auto(){
		$this->exec('--auto');
		return $this;
	}
	public function leftOf($name){
		$this->exec('--left-of '.$name);
		return $this;
	}
	public function rightOf($name){
		$this->exec('--right-of '.$name);
		return $this;
	}
	public function primary(){
		$this->exec('--primary');
		return $this;
	}
	public function pos($pos){
		$this->exec('--pos '.$pos);
		return $this;
	}
}/*}}}*/

$args = array_slice($argv,1);
$monitors = new Monitors();
switch($args[0]){
	case 3:
		$monitors->get('HDMI3')->primary()->auto();
		$monitors->get('HDMI2')->auto()->rightOf('HDMI3');
		$monitors->get('LVDS1')->auto()->leftOf('HDMI3')->pos('0x312');
		break;
	case 2:
		$monitors->get('HDMI3')->primary()->auto();
		$monitors->get('HDMI2')->auto()->rightOf('HDMI3');
		$monitors->get('LVDS1')->off();
		break;
	case 1:
		$monitors->turnOffAllExcept('LVDS1');
		$monitors->get('LVDS1')->auto()->primary();
		break;
	default:
		echo "Unknown command\n";
}


#xrandr --output LVDS1 --auto --output HDMI3 --auto --right-of LVDS1
#xrandr --output LVDS1 --auto --output HDMI3 --auto --right-of LVDS1

#if [ $1 -eq 3 ]; then
	#xrandr --output HDMI3 --auto --primary --output HDMI1 --auto --right-of HDMI3 --output LVDS1 --auto --left-of HDMI3
	#xrandr --output LVDS1 --pos 0x312
#elif [ $1 -eq 2 ]; then
	#xrandr --output HDMI3 --auto --primary --output HDMI1 --auto --right-of HDMI3 --output LVDS1 --off
#elif [ $1 -eq 1 ]; then
	#xrandr --output LVDS1 --auto --primary --output HDMI1 --off --output HDMI3 --off
#else
   #echo "Unkown parameter"
#fi

#alla tre
#xrandr --output HDMI3 --auto --primary --output HDMI2 --auto --right-of HDMI3 --output LVDS1 --auto --left-of HDMI3

#2 externa
#xrandr --output HDMI3 --auto --primary --output HDMI1 --auto --right-of HDMI3 --output LVDS1 --off

#laptop + 1 extern
#xrandr --output HDMI3 --auto --primary --output LVDS1 --auto --left-of HDMI3
