.386				
.model flat, stdcall	
option casemap: none

include d:\masm32\include\windows.inc
include d:\masm32\include\wsock32.inc
include d:\masm32\include\kernel32.inc
include d:\masm32\include\masm32.inc

         
includelib d:\masm32\lib\wsock32.lib             
includelib d:\masm32\lib\kernel32.lib
includelib d:\masm32\lib\masm32.lib
                            



.data   
	welcome_message	db "===== Welcome To This Assembly Client =====",13,10,0
	error_socket db "SOCKET NOT VAILD !",13,10,0
 	error_connect db "CONNECT ERROR !",13,10,0
	good_socket db "Socket Creaet Successful !",13,10,0
	good_connect db "Connect Done !",13,10,0
	LOCAL_HOST db "127.0.0.1",0
	
	label_message db "Message > ",0
	server_echo db "Server Echo > ",0
	new_line db 13,10,0
	empty db 0
	
	user_input db 512 dup(0)
	recv_message db 512 dup(0)
.data?
	client SOCKET ?
	wsaData   WSADATA <>
    server_sin sockaddr_in  <>
.code

start:
	invoke StdOut, addr  welcome_message
	invoke WSAStartup,0101h,addr wsaData
	invoke  socket, AF_INET, SOCK_STREAM,0
	mov client , eax
    .if client == INVALID_SOCKET
    	invoke StdOut, addr error_socket
    	invoke ExitProcess,0
	.else
		invoke StdOut, addr  good_socket
    .endif
	mov server_sin.sin_family, AF_INET
	invoke htons,8080
    mov server_sin.sin_port, ax
	invoke inet_addr, addr LOCAL_HOST
	mov server_sin.sin_addr, eax
	invoke connect, client,addr server_sin,sizeof server_sin
	.if eax == SOCKET_ERROR
		invoke StdOut, addr error_connect
	.else
		invoke StdOut,addr good_connect
	.endif
	.while 1
		
		invoke StdOut, addr label_message
		invoke StdIn, addr user_input,512
		invoke send, client, addr user_input, sizeof user_input,0
		mov edi, offset user_input
		call ZeroBuffer
		recv_again:	
		invoke recv, client , offset recv_message , 500,0
		invoke lstrcmpiA, addr recv_message, addr empty
		or eax,eax
		jz recv_again 
		invoke StdOut, addr server_echo
		invoke StdOut, addr recv_message
		;invoke StdOut, addr new_line ; No Need Server Append New line To message
		mov edi, offset recv_message
		call ZeroBuffer
	.endw
	invoke ExitProcess, 0

ZeroBuffer:
	xor edx,edx
	mov [edi],edx
	add edi, 4
	mov ebx,[edi]
	test ebx, ebx
	jnz ZeroBuffer
	ret

end start
