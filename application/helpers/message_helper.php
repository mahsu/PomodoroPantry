<?php
/**
 * assists in the creation of custom information, warning, or error messages based on the bootstrap formatting
 *
 * @param string $message               message to be displayed (raw html)
 * @param int $warninglevel             0-2; 0 is least critical, 2 is most critical
 *        0 = blue info
 *        1 = green success
 *        2 = yellow warning
 *        3 = red error
 * @return string                       fully generated html of warning label
 */
function message($message = '', $warninglevel = 0)
{
    $dismiss = '<button type="button" class="close" data-dismiss="alert">&times;</button>';
    switch ($warninglevel) {
        case 0:
            return '<div class="alert alert-info">' . $dismiss . $message . '</div>';
        case 1:
            return '<div class="alert alert-success">' . $dismiss . $message . '</div>';
        case 2:
            return '<div class="alert">' . $dismiss . $message . '</div>';
        case 3:
            return '<div class="alert alert-danger">' . $dismiss . $message . '</div>';
    }
}