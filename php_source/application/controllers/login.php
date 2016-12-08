<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
ini_set( 'display_errors', 1 );

class Login extends CI_Controller {
	public function __construct(){
		parent::__construct();

        $this->load->model('admin_model');
	}

	public function index()
	{
		$name = $this->input->post('name');
		$pass = $this->input->post('pass');

		if($name != null && $pass != null){
            $data = array();
			$data = $this->admin_model->login($name, $pass);
			if(isset($data['admin_id'])){
                $this->session->set_userdata($data);
				header("Location: admin");
				exit;
			}else{
				$d['error'] = "could not log in";
                $d['name'] = $name;
                $d['pass'] = $pass;
                $d['header'] = $this->load->view('header.html', true);
				$this->load->view('login.html', $d);
			}
		}else{
            //どっちかが空欄だったら処理しない
			$d['error'] = "";
            $d['name'] = $name;
            $d['pass'] = $pass;
            $d['header'] = $this->load->view('header.html', true);
			$this->load->view('login.html', $d);
		}
	}

	public function logout(){
		$this->session->unset_userdata('mate_id');
		$this->session->sess_destroy();
		header("Location: ../login");
	}
}
?>