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

import java.util.List;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;

import com.google.appengine.api.users.User;

public class CollectionDetailsDAO {

	public static CollectionDetails store(final PersistenceManager pm, final User user) {
		CollectionDetails cd = new CollectionDetails();
		cd.setName("My collection of MWC 2012 Android pins");
		cd.setUser(user.getUserId());
		pm.makePersistent(cd);
		return cd;
	}

	public static CollectionDetails getForUser(final PersistenceManager pm, final String userId) {
		Query query = pm.newQuery(CollectionDetails.class);
		query.setFilter("user == userParam");
		query.declareParameters("String userParam");
		@SuppressWarnings("unchecked")
		List<CollectionDetails> details = (List<CollectionDetails>) query.execute(userId);
		if(details == null || details.size() == 0 ) {
			return null;
		}
		return details.get(0);
	}

}
