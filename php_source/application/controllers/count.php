<? if ( ! defined('BASEPATH')) exit('No direct script access allowed');

ini_set( 'display_errors', 1 );

class Count extends CI_Controller{
    public function __construct(){
        parent::__construct();

        $this->load->model('link_model');
    }
    
    function index(){
        
        // ログイン状態のチェック
        $admin_id = $this->session->userdata('admin_id');
        if ($admin_id > 0) {
            $cid = $this->uri->segment(3);
            $d['session'] = 1;
            $d['counts'] = $this->link_model->get_count_list($cid);
            $this->load->view('count.html', $d);
        }else{
            header("Location: ../../login");
        }
    }
    
    function link(){

        $this->load->helper('url');

        $link_id = $this->uri->segment(3);
        $link = $this->link_model->link_url($link_id);
        if(isset($link['url'])){
            $this->link_model->count_up($link_id);
            redirect($link['url']);
        }else{
            echo "This link has expired.";
        }
    }
    
}
?>