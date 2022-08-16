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
	welcome_message	db "===== Welcome To This Assembly Server =====",13,10,0
 	error_socket db "SOCKET NOT VAILD !",13,10,0
 	error_bind db "BIND ERROR !",13,10,0
	good_socket db "Socket Creaet Successful !",13,10,0
	good_bind db "Bind Done !",13,10,0
	listen_message db "Start Listen...",13,10,0
	new_client_connect_message db "New Client Connect!",13,10,0
	new_message_client db "Client Send => ",0
	new_line db 13,10,0
	empty db 0
	client_recv db 512 dup(0) 
	server_send db 512 dup(0)
.data?
	  client SOCKET ?
      server SOCKET ?
	  wsaData   WSADATA <>
      server_sin sockaddr_in  <>
	  client_sin sockaddr_in  <>
	  ctmp dd ?
.code

start:

    invoke StdOut, addr  welcome_message
	invoke WSAStartup,0101h,addr wsaData
	invoke  socket, AF_INET, SOCK_STREAM,0
	mov server , eax
    .if server == INVALID_SOCKET
    	invoke StdOut, addr error_socket
    	invoke ExitProcess,0
	.else
		invoke StdOut, addr  good_socket
    .endif
    
    
    mov server_sin.sin_family, AF_INET
    mov server_sin.sin_addr,0 ; Any  127.0.0.1 or ::1
    invoke htons,8080
    mov server_sin.sin_port, ax
    invoke bind,server,addr server_sin,sizeof sockaddr_in
	.if eax == SOCKET_ERROR
		invoke StdOut,addr  error_bind
    	invoke ExitProcess,0
	.else
		invoke StdOut,addr  good_bind
	.endif
    
    
    invoke listen, server, 1
	start_accept:
    invoke StdOut, addr listen_message
	mov ctmp ,  sizeof sockaddr_in
	invoke accept, server,addr server_sin,addr ctmp
	mov client, eax
	invoke StdOut, addr new_client_connect_message
	.while 1
		lop:
		invoke recv, client , offset client_recv , 500,0
		or eax,eax
		jz lop
		.if eax == SOCKET_ERROR
			jmp start_accept
		.endif
		
		invoke lstrcmpiA, addr client_recv, addr new_line
		or eax,eax
		jz lop
		invoke lstrcmpiA, addr client_recv, addr empty
		or eax,eax
		jz lop 

		invoke StdOut, addr new_message_client
		invoke StdOut, addr client_recv

		invoke lstrcpyA, addr server_send, addr client_recv 
		invoke lstrcatA, addr server_send, addr new_line 
		invoke send, client, addr server_send, sizeof server_send,0
		mov edi, offset client_recv
		call ZeroBuffer
		
		mov edi, offset server_send
		call ZeroBuffer
		invoke StdOut, addr new_line
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
