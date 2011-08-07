<?php
// wcf imports
require_once(WCF_DIR.'lib/data/shoutbox/ShoutboxEntryFactory.class.php');
require_once(WCF_DIR.'lib/system/event/EventListener.class.php');

/**
 * Shows the shoutbox on the burning board index page.
 * 
 * @author	Sebastian Oettl
 * @copyright	2009-2011 WCF Solutions <http://www.wcfsolutions.com/index.html>
 * @license	GNU Lesser General Public License <http://opensource.org/licenses/lgpl-license.php>
 * @package	com.wcfsolutions.wcf.shoutbox.wbb
 * @subpackage	system.event.listener
 * @category	Burning Board
 */
class IndexPageShoutboxListener implements EventListener {
	/**
	 * @see EventListener::execute()
	 */
	public function execute($eventObj, $className, $eventName) {
		if (MODULE_SHOUTBOX && INDEX_ENABLE_SHOUTBOX && WCF::getUser()->getPermission('user.shoutbox.canViewShoutbox')) {
			// init shoutbox entry factory
			$factory = new ShoutboxEntryFactory();
			$factory->init();
			
			// get status
			if (WCF::getUser()->userID) {
				$status = intval(WCF::getUser()->shoutboxBoxStatus);
			}
			else {
				if (($status = WCF::getSession()->getVar('shoutboxBoxStatus')) === null) {
					$status = 1;
				}
			}
			
			// register special styles
			WCF::getTPL()->append('specialStyles', '<link rel="stylesheet" type="text/css" media="screen" href="'.RELATIVE_WBB_DIR.'style/shoutbox.css" />');
			
			// assign variables
			WCF::getTPL()->assign(array(
				'smileys' => $factory->getSmileys(),
				'shoutboxEntries' => $factory->getEntries(),
				'shoutboxBoxStatus' => $status,
				'username' => WCF::getSession()->username
			));
			WCF::getTPL()->append('additional'.ucfirst(INDEX_SHOUTBOX_POSITION).'Contents', WCF::getTPL()->fetch('indexShoutbox'));
		}
	}
}
?>