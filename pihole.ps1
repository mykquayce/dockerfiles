docker pull pihole/pihole:latest | findstr -I "Status:" | findstr -I "Downloaded newer"

if($?)
{
	docker build --tag eassbhhtgu/pihole:latest --file ./pihole-dockerfile .
	docker push eassbhhtgu/pihole:latest
}

exit 0
