<div class="border titleBarPanel">
	<div class="containerHead">
		<div class="containerIcon">
			<a onclick="openList('shoutboxBoxStatus', { save: true })"><img src="{icon}minusS.png{/icon}" id="shoutboxBoxStatusImage" alt="" /></a>
		</div>
		<div class="containerContent">
			<h3>{lang}wbb.shoutbox.title{/lang}</h3>
		</div>
	</div>
</div>
<div class="border borderMarginRemove infoBox" id="shoutboxBoxStatus">
	<div class="container-1">
		<script type="text/javascript" src="{@RELATIVE_WCF_DIR}js/Shoutbox.class.js"></script>
		<script type="text/javascript">
		//<![CDATA[
			var shoutboxEntries = new Hash();
			{foreach from=$shoutboxEntries item=entry}
				shoutboxEntries.set({@$entry->entryID}, {
					userID: {@$entry->userID},
					username: '{@$entry->getStyledUsername()|encodeJS}',
					time: '{@$entry->time|shorttime|encodeJS}',
					message: '{@$entry->getFormattedMessage()|encodeJS}',
					isDeletable: {$entry->isDeletable()|intval}
				});
			{/foreach}

			// init
			onloadEvents.push(function() {
				shoutbox = new Shoutbox('shoutbox', shoutboxEntries, {TIME_NOW}, {
					langDeleteEntry:	'{lang}wcf.shoutbox.entry.delete{/lang}',
					langDeleteEntrySure:	'{lang}wcf.shoutbox.entry.delete.sure{/lang}',
					imgDeleteEntrySrc:	'{icon}deleteS.png{/icon}',
					entryReloadInterval: 	{SHOUTBOX_RELOAD_INTERVAL},
					entrySortOrder: 	'{SHOUTBOX_ENTRY_SORT_ORDER}',
					unneededUpdateLimit:	{SHOUTBOX_UNNEEDED_UPDATE_LIMIT}
				});
			});
		//]]>
		</script>
		<div class="border infoBox">
			<div class="container-1" id="shoutboxContent">
				{assign var=sortedShoutboxEntries value=$shoutboxEntries|array_reverse}
				{foreach from=$sortedShoutboxEntries item=entry}
					<p id="shoutboxEntry{@$entry->entryID}"><span class="light">[{@$entry->time|shorttime}]</span>{if $entry->isDeletable()} <a href="index.php?action=ShoutboxEntryDelete&amp;entryID={@$entry->entryID}&amp;t={@SECURITY_TOKEN}{@SID_ARG_2ND}" title="{lang}wcf.shoutbox.entry.delete{/lang}"><img src="{icon}deleteS.png{/icon}" alt="" /></a>{/if} {if $entry->userID != 0}<a href="index.php?page=User&userID={@$entry->userID}{@SID_ARG_2ND}">{@$entry->getStyledUsername()}</a>{else}{@$entry->getStyledUsername()}{/if}: {@$entry->getFormattedMessage()}</p>
				{/foreach}
			</div>
		</div>
		{if $this->user->getPermission('user.shoutbox.canAddEntry')}
			{if SHOUTBOX_ENABLE_SMILEY_LIST}
				<div class="hidden" id="shoutboxSmileyContainer">
					<ul class="smileys">{foreach from=$smileys item=smiley}<li><img onmouseover="this.style.cursor='pointer'" onclick="shoutbox.insertSmiley('{$smiley->smileyCode|encodeJS}');" src="{$smiley->getURL()}" alt="" title="{lang}{$smiley->smileyTitle}{/lang}" /></li>{/foreach}</ul>
				</div>
			{/if}
			<form method="post" action="index.php?action=ShoutboxEntryAdd" id="shoutboxEntryAddForm">
				<div id="shoutboxFormLayout-{if $this->user->userID == 0}2{else}1{/if}">
					{if $this->user->userID == 0}
						<input type="text" class="inputText" name="username" id="shoutboxUsername" value="{if $username|empty}{lang}wcf.user.username{/lang}{else}{$username}{/if}" onfocus="if (this.value == '{lang}wcf.user.username{/lang}') this.value='';" onblur="if (this.value == '') this.value = '{lang}wcf.user.username{/lang}'" />
					{/if}
					<input type="text" class="inputText" name="message" id="shoutboxMessage" value="" />
					<input type="image" class="inputImage" id="shoutboxSubmit" src="{icon}submitS.png{/icon}" />
					{@SID_INPUT_TAG}
				</div>
			</form>
		{/if}
	</div>
</div>
<script type="text/javascript">
	//<![CDATA[
	initList('shoutboxBoxStatus', {@$shoutboxBoxStatus});
	//]]>
</script>