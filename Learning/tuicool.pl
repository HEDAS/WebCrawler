#!E:\Software\Strawberry\perl\bin\perl.exe
use strict;
use warnings FATAL => 'all';
# perl Learning/tuicool.pl http://www.php-oa.com

# ======================================================================================================================
# File Description
# 功能：推酷伯乐在线
# 说明：扶凯爬虫
# 作者：cucud
# 时间：2018/12/24 1:23
# ======================================================================================================================
#!/usr/bin/perl
use strict;
use Mojo::UserAgent;
use Bloom::Filter;

my $filter = Bloom::Filter->new(capacity => 100000, error_rate => 0.0001);
my $ua = Mojo::UserAgent->new;

my $delay = Mojo::IOLoop->delay;
my $end = $delay->begin(0);

my $callback;
$callback = sub  {
    my ($ua, $tx) = @_;
    $end->() if !$tx->result->is_success;

    $tx->res->dom->find("a[href]")->each(sub{
        my $attr  = shift->attr;
        my $newUrl = $attr->{href};
        next if (!$newUrl =~ /yooomu.com/);
        if( !$filter->check($newUrl) ) {
            print $filter->key_count(), " ", $newUrl, "\n";
            $filter->add($newUrl);
            $ua->get($newUrl => $callback);
        }
        sleep(0.5);
    });
    $end->();
};

$ua->get($ARGV[0] => $callback);

Mojo::IOLoop->start;

# perl Learning/tuicool.pl http://www.php-oa.com