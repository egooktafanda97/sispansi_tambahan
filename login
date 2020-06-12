 //Tambahin fungi ini di login
 function cek_post(){
         $password = $_POST['password'];
         $username = $_POST['username'];
         $credential    =   array(  'name' => $username, 'password' => sha1($password) );
         $query = $this->db->get_where('user' , $credential);
         if ($query->num_rows() > 0) {
          $result = [
            [
                "rows" => 'Login Berhasil'
            ]
          ];
            $ison = json_encode(array('result'=>$result));
            echo $ison;
        }else{
           $result = [
            [
                "rows" => 'gagal Login'
            ]
          ];
            $ison = json_encode(array('result'=>$result));
            echo $ison; 
        }
       
        
    }
    function validate_login_android(){
        $this->load->helper('cookie');
        $email      =   $_POST['username'];
        $password   =   $_POST['password'];

        $credential =   array(  'name' => $email , 'password' => sha1($password) );

        // Checking login credential for users of the system
        $query = $this->db->get_where('user' , $credential);
        if ($query->num_rows() > 0) {
            $row = $query->row();

            //setting the session parameters for admin
            if ($row->type == 1) {
                $this->session->set_userdata('admin_login' , '1');
                $this->session->set_userdata('login_type' , 'admin');
            }

            //setting the session parameters for employees
            if ($row->type == 2 || $row->type == 3) {
                $this->session->set_userdata('employee_login' , '1');
                $this->session->set_userdata('login_type' , 'employee');
            }
            //setting the common session parameters for all type of users of the system
            $this->session->set_userdata('login_user_id' , $row->user_id);
            $this->session->set_userdata('type' , $row->type);
            $cookie= array(

               'name'   => 'user_id',
               'value'  =>  $row->user_id,                            
               'expire' => '7200',                                                                                   
               'secure' => TRUE
    
           );
    
           $this->input->set_cookie($cookie);
            redirect(site_url($this->session->userdata('login_type').'/dashboard'), 'refresh');
        } else {
            $this->session->set_flashdata('login_error', 'Invalid Login');
            redirect(site_url('login'), 'refresh');
        }
    }
