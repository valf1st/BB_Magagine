<?php

	class Admin_model extends CI_Model
	{
		public function __construct()
		{
			parent::__construct();
			// 独自処理
		}

//----SELECT----------------------------------------

        function login($name, $pass){
            $this->db->where('admin_name', $name);
            $this->db->where('password', $pass);
			$this->db->where('is_del', '0');
            $query = $this->db->get('admin');

            if ($query->num_rows() > 0){
                $row = $query->row_array();
                return $row;
            }else{
                return 0;
            }

            /*$query = $this->db->query("SELECT * FROM mate WHERE email = '".$email."' AND password = '".$pass."' AND is_del = '0'");
            $row = $query->row_array();
            return $row;*/
        }
    }


