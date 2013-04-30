class delhost ($dhost){
	host { $dhost:
		ensure => "absent",
	}
}
