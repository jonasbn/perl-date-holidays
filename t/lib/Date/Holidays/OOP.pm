package Date::Holidays::OOP;

sub new {
    my $class = shift;    

    my $self = bless {
        calendar => { 1224 => 'christmas' }
    }, $class || ref $class;
    
    return $self;
}

sub holidays {
    my $self = shift;
    
    return $self->{calendar};    
}

sub is_holiday {
    my ($self, %params) = @_;
    
    my $key;
    if ($params{month} && $params{day}) {
        $key  = $params{month}.$params{day};
    }

    if ($key && $self->{calendar}->{$key}) {
        return $self->{calendar}->{$key};
    }
}

1;
