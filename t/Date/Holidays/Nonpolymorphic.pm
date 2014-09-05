package Date::Holidays::Nonpolymorphic;

sub new {
    my $class = shift;    

    my $self = bless {
        calendar => { 1224 => 'christmas' },              
    }, $class || ref $class;
    
    return $self;
}

sub nonpolymorphic_holidays {
    my $self = shift;
    
    return $self->{calendar};        
}

sub is_nonpolymorphic_holiday {
    my ($self, %params) = @_;
    
    my $key = $params{month}.$params{day};
    if (exists $self->{calendar}->{$key}) {
        return $self->{calendar}->{$key};
    }
}

1;
