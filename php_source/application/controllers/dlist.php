<? if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Dlist extends CI_Controller{
    public function __construct(){
        parent::__construct();
        
        $this->load->model('contents_model');
        $this->load->model('link_model');
    }
    
    function index(){
        //最新号を取得
        $list = $this->contents_model->get_latest(15);
        if($list){
            //echo $latest['volume']." found";
            for($i=0 ; $i<count($list) ; $i++){
                $array = array();
                if ($handle = opendir('contents/'.$list[$i]['content_id'])){
                    while (false !== ($file = readdir($handle))){
                        if(strpos($file, 'jpg') || strpos($file, 'png')){
                            if($file != "thumb.jpg"){
                                $array[] = $file;
                            }
                        }
                    }
                    closedir($handle);
                }
                $list[$i]['first'] = reset($array);
                $list[$i]['last'] = end($array);
                $list[$i]['num'] = count($array);
            }
            echo json_encode($list);
        }else{
            echo "nothing available";
        }
    }

    function download(){
        $contents_id = $this->input->post('cid');
        if(file_exists('contents/'.$contents_id)){
            $images = array();
            if ($handle = opendir('contents/'.$contents_id)){
                while (false !== ($file = readdir($handle))){
                    if(strpos($file, 'jpg') || strpos($file, 'png')){
                        if($file != "thumb.jpg"){
                            $images[] = $contents_id."/".$file;
                        }
                    }
                }
                $array['images'] = $images;
                closedir($handle);
            }
            $links = $this->link_model->get_links($contents_id);
            if(count($links)>0){
                $array['links'] = $links;
            }else{
                $array['links'] = null;
            }
            $array['cid'] = $contents_id;
            echo json_encode($array);
        }
    }
    

    function drest(){
        $contents_id = $this->input->post('cid');
        $page = $this->input->post('page');
        if(file_exists('contents/'.$contents_id)){
            $images = array();
            if ($handle = opendir('contents/'.$contents_id)){
                while (false !== ($file = readdir($handle))){
                    if(strpos($file, 'jpg') || strpos($file, 'png')){
                        if($file != "thumb.jpg"){
                            $images[] = $contents_id."/".$file;
                        }
                    }
                }
                foreach($images as $key => $image){
                    if($key >= $page){
                        $rimages[] = $image;
                    }
                }
                $array['images'] = $rimages;
                closedir($handle);
            }
            $array['cid'] = $contents_id;
            echo json_encode($array);
        }
    }



}
?>