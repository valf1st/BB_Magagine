<?php
    
    class Contents_model extends CI_Model
    {
        public function __construct()
        {
            parent::__construct();
            // 独自処理
        }
        
        //----SELECT----------------------------------------
        function get_latest($num){
            
            $this->db->where('is_del', '0');
            $this->db->where('exists', '1');
            $this->db->order_by('release_date', 'desc');
            $query = $this->db->get('contents', $num, 0);
            if ($query->num_rows() > 0)
            {
                $result = $query->result_array();
                return $result;
            }else{
                return null;
            }
        }

        function show_admin($num, $offset){
            $this->db->order_by('release_date', 'desc');
            $query = $this->db->get('contents', $num, $offset);
            if ($query->num_rows() > 0)
            {
                $result = $query->result_array();
                return $result;
            }else{
                return null;
            }
        }

        function content_info($cid){
            $this->db->where('content_id', $cid);
            $query = $this->db->get('contents');
            if ($query->num_rows() > 0)
            {
                $result = $query->row_array();
                return $result;
            }else{
                return null;
            }
        }

        //----INSERT----------------------------------------
        function add_new($volume, $year, $month, $date){
            $release_date = $year."-".$month."-".$date;
            $data = array(
                          'volume' => $volume,
                          'release_date' => $release_date
                          );
            $this->db->insert('contents', $data);

            $last_id = $this->db->insert_id();
            
            return $last_id;
        }
        
        //----UPDATE-----------------------------------------
        function edit($cid, $volume, $date, $caption){
            $data = array(
                          'volume' => $volume,
                          'release_date' => $date,
                          'caption' => $caption
                          );
            
            $this->db->where('content_id', $cid);
            $this->db->update('contents', $data);
            
            return $cid;
        }

        function approve($contents_id){
            $data = array(
                          'exists' => 1
                          );
            
            $this->db->where('content_id', $contents_id);
            $this->db->update('contents', $data);
        }

        function delete($contents_id){
            $data = array(
                          'is_del' => 1
                          );
            
            $this->db->where('content_id', $contents_id);
            $this->db->update('contents', $data);
        }
    }
    
    ?>