<?php
    
    class Link_model extends CI_Model
    {
        public function __construct()
        {
            parent::__construct();
            // 独自処理
        }
        
        //----SELECT----------------------------------------
        function get_links($cid){

            $this->db->select('link_id, page, section');
            $this->db->where('content_id', $cid);
            $this->db->where('is_del', 0);
            $this->db->order_by('page', 'desc');
            $query = $this->db->get('link');
            if ($query->num_rows() > 0)
            {
                $result = $query->result_array();
                return $result;
            }else{
                return null;
            }
        }

        function get_link_url($cid){
            
            $this->db->select('link_id, page, url');
            $this->db->where('content_id', $cid);
            $this->db->where('is_del', 0);
            $this->db->order_by('page', 'desc');
            $query = $this->db->get('link');
            if ($query->num_rows() > 0)
            {
                $result = $query->result_array();
                return $result;
            }else{
                return null;
            }
        }

        function link_url($lid){

            $this->db->select('url');
            $this->db->where('link_id', $lid);
            $this->db->where('is_del', 0);
            $query = $this->db->get('link');
            if ($query->num_rows() > 0)
            {
                $result = $query->row_array();
                return $result;
            }else{
                return null;
            }
        }

        function get_page_links($cid, $page){
            $this->db->select('link_id, page, section, url');
            $this->db->where('content_id', $cid);
            $this->db->where('page', $page);
            $this->db->where('is_del', 0);
            $this->db->order_by('page', 'desc');
            $query = $this->db->get('link');
            if ($query->num_rows() > 0)
            {
                $result = $query->result_array();
                return $result;
            }else{
                return null;
            }
        }

        function get_count($lid){
            
            $this->db->select('count');
            $this->db->where('link_id', $lid);
            $query = $this->db->get('link');
            if ($query->num_rows() > 0)
            {
                $result = $query->row_array();
                return $result;
            }else{
                return null;
            }
        }

        function get_count_list($cid){

            $this->db->where('content_id', $cid);
            $query = $this->db->get('link');
            if ($query->num_rows() > 0)
            {
                $result = $query->result_array();
                return $result;
            }else{
                return null;
            }
        }

        //----INSERT-----------------------------------------
        function add_link($cid, $page, $link, $section){
            $data = array(
                          'content_id' => $cid,
                          'page' => $page,
                          'section' => $section,
                          'url' => $link
                          );
            $this->db->insert('link', $data);
            
            $last_id = $this->db->insert_id();
            
            return $last_id;
        }

        //----UPDATE-----------------------------------------
        function count_up($id){

            $count = $this->get_count($id);
            $count = $count['count'] + 1;

            $data = array(
                          'count' => $count
                          );
            
            $this->db->where('link_id', $id);
            $this->db->update('link', $data);
            
            return $id;
        }
        
        
        function del_link($link_id){
            $data = array(
                          'is_del' => 1
                          );
            
            $this->db->where('link_id', $link_id);
            $this->db->update('link', $data);
        }
    }
    
    ?>