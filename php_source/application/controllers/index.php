<? if ( ! defined('BASEPATH')) exit('No direct script access allowed');

    class Index extends CI_Controller{
        public function __construct(){
            parent::__construct();
            
            //$this->load->model('mate_model');
        }

        function index(){
            echo "index";
        }
    }
    ?>