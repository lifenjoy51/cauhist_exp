/**
 * This jQuery plugin displays pagination links inside the selected elements.
 * 
 * @author Gabriel Birke (birke *at* d-scribe *dot* de)
 * @version 1.2
 * @param {int}
 *            maxentries Number of entries to paginate
 * @param {Object}
 *            opts Several options (see README for documentation)
 * @return {Object} jQuery Object
 */
jQuery.fn.paging = function(opts) {
	opts = jQuery.extend({
		obj_id : 'paging',
		total_cnt : 1,
		rows_per_page : 10,
		num_display_entries : 15,
		current_page : 1,
		link_to : "#",
		first_text : "First",
		prev_text : "Prev",
		next_text : "Next",
		last_text : "Last",
		ellipse_text : "...",
		first_show_always : true,
		prev_show_always : true,
		next_show_always : true,
		last_show_always : true,
		user_function : 'drawPaging'
	}, opts || {});

	// Extract current_page from options
	var current_page = opts.current_page;

	// Create a sane value for maxentries and rows_per_page
	total_cnt = (!opts.total_cnt || opts.total_cnt < 0) ? 1 : opts.total_cnt;
	opts.rows_per_page = (!opts.rows_per_page || opts.rows_per_page < 0) ? 10
			: opts.rows_per_page;

	// Store DOM element for easy access from all inner functions
	var panel = jQuery(this);

	// Attach control functions to the DOM element
	this.selectPage = function(page_id) {
		pageSelected(page_id);
	};

	this.prevPage = function() {
		if (current_page > 0) {
			pageSelected(current_page - 1);
			return true;
		} else {
			return false;
		}
	};

	this.nextPage = function() {
		if (current_page < numPages() - 1) {
			pageSelected(current_page + 1);
			return true;
		} else {
			return false;
		}
	};

	/**
	 * This is the event handling function for the pagination links.
	 * 
	 * @param {int}
	 *            page_id The new page number
	 */
	function pageSelected(page_id) {
		current_page = page_id;
		drawLinks();
		return;
	}

	/**
	 * This function inserts the pagination links into the container element
	 */
	function drawLinks() {

		// Helper function for generating a single link (or a span tag if it's
		// the current page)
		var appendItem = function(page_id, appendopts) {
			page_id = page_id < 0 ? 0 : (page_id < np ? page_id : np); // Normalize
			// page
			// id to
			// sane
			// value
			appendopts = jQuery.extend({
				text : page_id,
				classes : ""
			}, appendopts || {});

			var lnk;

			if (page_id == 0) {
				page_id = 1; // 이전페이지가 0으로가는걸 막음. 위에서 페이지를 바꾸지 않은건 버튼을 생성하기
				// 위해.
			} else if (page_id == np + 1) {
				page_id = np; // 다음페이지가 마지막을 초과하지 않게
			}
			if (page_id == current_page) {
				lnk = jQuery("<span class='current'>" + (appendopts.text)
						+ "</span>"); // 현재페이지는 클릭없음
			} else {
				lnk = jQuery("<a>" + (appendopts.text) + "</a>").attr(
						'onClick',
						'javascript:' + opts.user_function + '(' + page_id
								+ ');').attr('id', opts.obj_id + '_' + page_id);
			}

			if (appendopts.classes) {
				lnk.addClass(appendopts.classes);
			}
			panel.append(lnk);
		};

		panel.empty(); // 이전정보 비우고
		var interval = getInterval(); // 시작과 끝지정
		var np = numPages(); // 전체페이지개수

		// Generate "First"-Link
		if (opts.first_text && (opts.first_show_always)) {
			appendItem(1, {
				text : opts.first_text,
				classes : "prev"
			}); // 처음으로
		}

		// Generate "Previous"-Link
		if (opts.prev_text && (current_page > 0 || opts.prev_show_always)) {
			appendItem(current_page - 1, {
				text : opts.prev_text,
				classes : "prev"
			});
		}

		// Generate interval links
		for ( var i = interval[0]; i <= interval[1]; i++) {
			appendItem(i);
		}

		// Generate "Next"-Link
		if (opts.next_text && (current_page < np - 1 || opts.next_show_always)) {
			appendItem(current_page + 1, {
				text : opts.next_text,
				classes : "next"
			});
		}

		// Generate "last"-Link
		if (opts.last_text && (opts.last_show_always)) {
			appendItem(np, {
				text : opts.last_text,
				classes : "next"
			});
		}

	}

	/**
	 * Calculate start and end point of pagination links depending on
	 * current_page and num_display_entries.
	 * 
	 * @return {Array}
	 */
	function getInterval() {
		var ne_half = Math.ceil(opts.num_display_entries / 2); // 페이징개수 절반을
		// 올림한거
		var np = numPages(); // 전체row개수에서 전체페이지개수를 계산
		var upper_limit = np - opts.num_display_entries; // 페이징개수
		var start = current_page > ne_half ? Math.max(Math.min(current_page
				- ne_half, upper_limit), 0) : 0;
		var end = current_page > ne_half ? Math.min(current_page + ne_half, np)
				: Math.min(opts.num_display_entries, np);
		return [ start + 1, end ]; // 시작개수와 끝지점
	}

	/**
	 * Calculate the maximum number of pages
	 */
	function numPages() {
		return Math.ceil(total_cnt / opts.rows_per_page);
	}

	// When all initialisation is done, draw the links
	drawLinks();

	return this;
};
