/*
 * Copyright (c) 2012, Funky Android Ltd.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the 
 * following conditions are met:
 * 
 * - Redistributions of source code must retain the above copyright notice, this list of conditions and the following 
 * disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following 
 * disclaimer in the documentation and/or other materials provided with the distribution.
 * - Neither the name of Funky Android nor the names of its contributors may be used to endorse or promote products derived 
 * from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, 
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
/*
 * Funky Android can be contacted via their web site at www.funkyandroid.com
 */
package com.androidpinexchange;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;

import com.google.appengine.api.users.User;

public class PinMessageDAO {

	private static Map<Integer,List<PinMessage>> MESSAGE_CACHE = new HashMap<Integer, List<PinMessage>>(51);

	public static void addMessage(final PersistenceManager pm, final User user, final int pin, final String messageText) {
		PinMessage message = new PinMessage();
		message.setMessage(messageText);
		message.setMessageTimestamp(Calendar.getInstance().getTimeInMillis());
		message.setName(user.getNickname());
		message.setPin(pin);
		message.setUser(user.getUserId());
		message.setEmail(user.getEmail());
		pm.makePersistent(message);

		List<PinMessage> existingMessages = getForPin(pm, pin);
		synchronized(existingMessages) {
			existingMessages.add(message);
			while( existingMessages.size() > 20 ) {
				existingMessages.remove(0);
			}
		}
	}

	public static List<PinMessage> getForPin(final PersistenceManager pm, final int pin) {
		synchronized(MESSAGE_CACHE) {
			List<PinMessage> existingMessages = MESSAGE_CACHE.get(pin);
			if(existingMessages != null) {
				return existingMessages;
			}

			existingMessages = getRecentForPin(pm, pin);
			if(existingMessages == null) {
				existingMessages = new ArrayList<PinMessage>();
			}
			MESSAGE_CACHE.put(pin, existingMessages);
			return existingMessages;
		}
	}

	@SuppressWarnings("unchecked")
	private static List<PinMessage> getRecentForPin(final PersistenceManager pm, final int pin) {
		Query query = pm.newQuery(PinMessage.class);
		query.setFilter("pin == pinParam");
		query.declareParameters("Integer userParam");
		query.setOrdering("messageTimestamp desc");
		query.setRange(0, 20);
		List<PinMessage> resultSet = (List<PinMessage>) query.execute(pin);
		List<PinMessage> results = new ArrayList<PinMessage>();
		for(PinMessage message : resultSet) {
			results.add(message);
		}
		return results;
	}

}
