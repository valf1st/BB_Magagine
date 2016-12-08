<? if ( ! defined('BASEPATH')) exit('No direct script access allowed');
ini_set( 'display_errors', 1 );
error_reporting(E_ALL);

class Admin extends CI_Controller{
    public function __construct(){
        parent::__construct();
        
        $this->load->model('contents_model');
        $this->load->model('link_model');
    }
    
    function index(){
        
        // ログイン状態のチェック
        $admin_id = $this->session->userdata('admin_id');
        if ($admin_id > 0) {
            $d['contents'] = $this->contents_model->show_admin(20, 0);
            $d['session'] = 1;
            $this->load->view('top.html', $d);
        }else{
            header("Location: ../../login");
        }
    }

    function edit(){
        // ログイン状態のチェック
        $admin_id = $this->session->userdata('admin_id');
        if ($admin_id > 0) {
            $cid = $this->uri->segment(3);
            $d['cid'] = $cid;
            $d['session'] = 1;
            $d['content'] = $this->contents_model->content_info($cid);
            $this->load->view('edit.html', $d);
        }else{
            header("Location: ../../login");
        }
    }

    function update(){
        $cid = $this->input->post('content_id');
        $volume = $this->input->post('volume');
        $release_date = $this->input->post('release_date');
        $caption = $this->input->post('caption');

        $this->contents_model->edit($cid, $volume, $release_date, $caption);
        header("Location: ../../admin");
    }

    function delete(){
        $cid = $this->uri->segment(3);
        
        $this->contents_model->delete($cid);
        header("Location: ../../admin");
    }

    function check(){
        // ログイン状態のチェック
        $admin_id = $this->session->userdata('admin_id');
        if ($admin_id > 0) {
            $cid = $this->uri->segment(3);
            $array = array();
            if ($handle = opendir('contents/'.$cid)){
                while (false !== ($file = readdir($handle))){
                    if(strpos($file, 'jpg') || strpos($file, 'png')){
                        $array[] = $file;
                    }
                }
                closedir($handle);
            }
            //$d['links'] = $this->link_model->get_link_url($cid);
            $d['cid'] = $cid;
            $d['array'] = $array;
            $d['session'] = 1;
            $this->load->view('check.html', $d);
        }else{
            header("Location: ../../login");
        }
    }

    function link(){
        $get = $this->input->get();
        $d['cid'] = $get['c'];
        $d['page'] = $get['p'];
        $d['image'] = $get['image'];

        $links = $this->link_model->get_page_links($get['c'], $get['p']);

        $d['session'] = 1;
        if(count($links)>0){
            foreach($links as $link){
                for($i=1 ; $i<=8 ; $i++){
                    if($link['section'] == $i){
                        $keys[] = $link['section'];
                        $values[] = $link;
                    }
                }
            }
            $d['ads'] = array_combine($keys, $values);
            $this->load->view('links_view.html', $d);
        }else{
            $this->load->view('links_form.html', $d);
        }
    }

    function link_set(){
        $cid = $this->input->post('cid');
        $page = $this->input->post('page');
        $image = $this->input->post('image');
        $links = array();
        $links['1'] = $this->input->post('link1');
        $links['2'] = $this->input->post('link2');
        $links['3'] = $this->input->post('link3');
        $links['4'] = $this->input->post('link4');
        $links['5'] = $this->input->post('link5');
        $links['6'] = $this->input->post('link6');
        $links['7'] = $this->input->post('link7');
        $links['8'] = $this->input->post('link8');

        for($i=1 ; $i<=8 ; $i++){
            if(strlen($links[$i])>4){
                $this->link_model->add_link($cid, $page, $links[$i], $i);
            }
        }
        header("Location: ../../admin/link?c=".$cid."&p=".$page."&image=".$image);
    }

    function link_add(){
        $cid = $this->input->post('cid');
        $page = $this->input->post('page');
        $image = $this->input->post('image');
        $link = $this->input->post('link');
        $section = $this->input->post('section');
        
        $this->link_model->add_link($cid, $page, $link, $section);
        header("Location: ../../admin/link?c=".$cid."&p=".$page."&image=".$image);
    }

    function link_delete(){
        $lid = $this->input->post('lid');
        $page = $this->input->post('page');
        $image = $this->input->post('image');
        $cid = $this->input->post('cid');
        
        $this->link_model->del_link($lid);
        header("Location: ../../admin/link?c=".$cid."&p=".$page."&image=".$image);
    }

    function add(){
        
        $volume = $this->input->post('volume');
        $year = $this->input->post('year');
        $month = $this->input->post('month');
        $date = $this->input->post('date');

        $insert = $this->contents_model->add_new($volume, $year, $month, $date);
        header("Location: ../../admin");
    }

    function approve(){
        $cid = $this->uri->segment(3);
        $this->contents_model->approve($cid);
        header("Location: ../../admin");
    }

}
?>