<?php
class Logger {
    private static $Initialized = false;
    public static $LogFileName;

    // Metodo di inizializzazione della classe Logger, per consentire la staticità della stessa
    private static function initialize() {
        if(self::$Initialized){
            return;
        }
        $date = date('Y_m_d');
        if (!file_exists('logs')) {
            mkdir('logs', 0777, true);
        }
        self::$LogFileName = "logs/APILogger_$date.log";
        self::$Initialized = true;
    }

    // Formatta la data
    private static function GetTimeStamp() {
        return date("Y-m-d H:i:s");
    }
    
    // Scrive sul file di log la stringa, e utilizza il correlation ID per dare continuità all'operazione
    function Write(string $text, string $correlationId) {
        self::initialize();
        $timeStamp = self::GetTimeStamp();
        $logText = "[$timeStamp] - $correlationId - $text ";
        file_put_contents(self::$LogFileName, "$logText\r\n", FILE_APPEND);
    }

    function WriteWithParameters($text, $parameters, string $correlationId) {
        self::initialize();
        for($i = 0; $i < count($parameters); $i++) {
            $text = $text." %s,";
        }
        $text = rtrim($text, ",");
        $text = vsprintf($text, $parameters);
        $timeStamp = self::GetTimeStamp();
        $logText = "[$timeStamp] - $correlationId - $text ";
        file_put_contents(self::$LogFileName, "$logText\r\n", FILE_APPEND);
    }

    function WriteNoCorrelation(string $text) {
        self::initialize();
        $timeStamp = self::GetTimeStamp();
        $logText = "[$timeStamp] - $text ";
        file_put_contents(self::$LogFileName, "$logText\r\n", FILE_APPEND);
    }
}
?>