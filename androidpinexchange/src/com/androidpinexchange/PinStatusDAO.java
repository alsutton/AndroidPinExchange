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
import java.util.List;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;

import com.google.appengine.api.users.User;

public class PinStatusDAO {

	private static int[] PIN_OFFER_COUNT_CACHE = null;

	private static final List<PinCount> SORTED_COUNT_CACHE = new ArrayList<PinCount>();

	private static boolean sortedCacheInvalid = true;

	public static void setInterested(final PersistenceManager pm, final User user, final int pin, final int newStatus) {
		PinStatus status = getStatus(pm, user, pin);
		if(status != null) {
			if(status.getStatus() == 2) {
				int[] cache = getOfferCounts(pm);
				cache[pin]--;
				sortedCacheInvalid = true;
			}
			status.setStatus(newStatus);
		} else {
			status = new PinStatus();
			status.setUser(user.getUserId());
			status.setPin(pin);
			status.setStatus(newStatus);
			pm.makePersistent(status);
		}
		if(newStatus == 2) {
			int[] cache = getOfferCounts(pm);
			cache[pin]++;
			sortedCacheInvalid = true;
		}
	}


	private static PinStatus getStatus(final PersistenceManager pm, final User user, final int pin) {
		Query query = pm.newQuery(PinStatus.class);
		query.setFilter("user == userParam && pin == pinParam");
		query.declareParameters("String userParam, Integer pinParam");
		@SuppressWarnings("unchecked")
		List<PinStatus> interests = (List<PinStatus>) query.execute(user.getUserId(), pin);
		if(interests.isEmpty()) {
			return null;
		}
		return interests.get(0);
	}

	public static PinStatuses getCollectionForUser(final PersistenceManager pm, final String userId) {
		PinStatuses result = new PinStatuses();
		for(int i = 0 ; i < 86 ; i++ ) {
			result.want.add(i);
		}

		Query query = pm.newQuery(PinStatus.class);
		query.setFilter("user == userParam");
		query.declareParameters("String userParam");
		@SuppressWarnings("unchecked")
		List<PinStatus> statuses = (List<PinStatus>) query.execute(userId);
		for(PinStatus status : statuses) {
			switch(status.getStatus()) {
			case 1:
				result.want.remove((Integer)status.getPin());
				result.have.add(status.getPin());
				break;
			case 2:
				result.want.remove((Integer)status.getPin());
				result.offering.add(status.getPin());
				break;
			default:
				break;
			}
		}

		return result;
	}

	public static List<Integer> getAllForUser(final PersistenceManager pm, final User user) {
		Query query = pm.newQuery(PinStatus.class);
		query.setFilter("user == userParam");
		query.declareParameters("String userParam");
		@SuppressWarnings("unchecked")
		List<PinStatus> statuses = (List<PinStatus>) query.execute(user.getUserId());

		List<Integer> results = new ArrayList<Integer>();
		for(PinStatus status : statuses) {
			results.add(status.getPin());
			results.add(status.getStatus());
		}

		return results;
	}

	public static List<PinCount> getSortedOfferCounts(final PersistenceManager pm) {
		if(sortedCacheInvalid) {
			int[] counts = getOfferCounts(pm);

			synchronized(SORTED_COUNT_CACHE) {
				SORTED_COUNT_CACHE.clear();
				for(int i = 0 ; i < counts.length ; i++) {
					boolean added = false;
					for(int j = 0 ; j < SORTED_COUNT_CACHE.size() ; j++) {
						PinCount thisCount = SORTED_COUNT_CACHE.get(j);
						if(thisCount.count < counts[i]) {
							SORTED_COUNT_CACHE.add(j, new PinCount(i, counts[i]));
							added = true;
							break;
						}
					}

					if(!added) {
						SORTED_COUNT_CACHE.add(new PinCount(i, counts[i]));
					}

				}
			}
		}

		return SORTED_COUNT_CACHE;
	}

	/**
	 * Gets the offer counts
	 */

	private static int[] getOfferCounts(final PersistenceManager pm) {
		synchronized (PinStatusDAO.class) {
			if(PIN_OFFER_COUNT_CACHE == null) {
				PIN_OFFER_COUNT_CACHE = new int[86];
				for(int i = 0 ; i < 86 ; i++) {
					Query query = pm.newQuery(PinStatus.class);
					query.setFilter("status == 2 && pin == pinParam");
					query.declareParameters("Integer pinParam");
					query.setResult("count(status)");
					Integer count = (Integer) query.execute(i);

					PIN_OFFER_COUNT_CACHE[i] = count;
				}
			}
		}

		return PIN_OFFER_COUNT_CACHE;
	}

	/**
	 * The counts for a person
	 */

	public static class PinStatuses {
		private final List<Integer> want = new ArrayList<Integer>(),
							  have = new ArrayList<Integer>(),
							  offering = new ArrayList<Integer>();

		public List<Integer> getWant() {
			return want;
		}

		public List<Integer> getHave() {
			return have;
		}

		public List<Integer> getOffering() {
			return offering;
		}
	}

	/**
	 * The count for a specific pin
	 */
	public static class PinCount {
		public final int pin;
		public final int count;

		PinCount(final int pin, final int count) {
			this.pin = pin;
			this.count = count;
		}

		public int getPin() {
			return pin;
		}

		public int getCount() {
			return count;
		}
	}
}
