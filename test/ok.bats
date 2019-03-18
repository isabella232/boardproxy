#!/usr/bin/env bats

setup() {
    docker run --name board-ok -p 8080:80 \
        -v $(pwd)/test/ok.html:/usr/share/nginx/html/ok.html \
        -v $(pwd)/test/nginx.conf:/etc/nginx/nginx.conf:ro -d nginx
}

teardown() {
    docker rm -f board-ok
}

#http() {
#    http -h --pretty=none
#}

@test "Responds OK to GET /boards" {
    run http GET :8080/boards -h --pretty none
    [[ ${lines[0]} =~ "HTTP/1.1 200 OK" ]]
}

@test "Responds OK to board update" {
    run http POST :8080/1/boards/5c8acc11bc371f1558970c98/markAsViewed \
       -h --pretty=none 
    [[ ${lines[0]} =~ "HTTP/1.1 200 OK" ]]
}

@test "Responds OK to board creation" {
    run http POST :8080/1/boards body="board creation" \
        -h --pretty=none
    [[ ${lines[0]} =~ "HTTP/1.1 200 OK" ]]
}

@test "Responds OK to team creation" {
    run http POST :8080/1/organizations body="team creation" \
        -h --pretty=none 
    [[ ${lines[0]} =~ "HTTP/1.1 200 OK" ]]
}