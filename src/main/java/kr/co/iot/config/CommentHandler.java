package kr.co.iot.config;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

public class CommentHandler extends TextWebSocketHandler {

	//모든 연결된 소켓세션으로 아이디를 담을 곳
	private Map<WebSocketSession, String> users
						= new HashMap<WebSocketSession, String>();
	//각 아이디별 연결된 소켓세션들를 담을 곳
	private Map<String, List<WebSocketSession>> sessions
						= new HashMap<String, List<WebSocketSession>>();
	
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		//메시지수신 시점: 연결될때, 댓글등록될때/댓글알림확인했을떄
		System.out.printf("\n수신> " + message.getPayload() );
		JSONObject json = new JSONObject( message.getPayload() );
		
		String receiver = json.getString("receiver");
		//사용자별 세션들
		ArrayList<WebSocketSession> receiverSessions = null;
		if( !sessions.containsKey(receiver) ) {
			sessions.put(receiver, new ArrayList<WebSocketSession>());
		}
		receiverSessions = (ArrayList<WebSocketSession>)sessions.get(receiver);
		receiverSessions.add(session);
		
		users.put(session, receiver);
		
		//댓글알림 수신자의 방명록글에 달린 미확인댓글갯수를 조회해와 브라우저에 전송
		int comments = sql.selectOne("board.commentCount", receiver);
		System.out.printf(" 미확인댓글수> %d개 [%s] \n" , comments , receiver );
		json.put( "comments" , comments );
		
		//해당 수신자로 연결된 모든 소켓세션에 보내기
		for(WebSocketSession ws  : receiverSessions) {
			if( ws.isOpen() ) {
				ws.sendMessage( new TextMessage( json.toString() ));
			}
		}
		
		System.out.println("연결된 모든 세션> ");
		for( WebSocketSession ws : users.keySet()) {
			System.out.print( ws + ":" + users.get(ws) + "\t");
		}
		
	}

	@Autowired @Qualifier("sql_hanul") private SqlSession sql;
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		//소켓세션연결이 끊겼을때
		String reciever = users.get(session); //연결이 끊긴 수신자
		if( users.containsKey(session) ) users.remove( session );
		
		ArrayList<WebSocketSession> receivers 
		   = (ArrayList<WebSocketSession>)sessions.get(reciever);
		if( receivers != null && receivers.contains(session) )  receivers.remove( session ); 
		
		
		
		
	}
	
	
}
