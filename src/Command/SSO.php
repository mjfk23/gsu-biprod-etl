<?php

declare(strict_types=1);

namespace Gsu\Biprod\Command;

use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Input\InputInterface;

#[AsCommand('biprod:sso')]
final class SSO extends Biprod
{
    /** @inheritdoc */
    protected function getShellArgs(InputInterface $input): array
    {
        return [
            [self::CONSOLE, 'biprod:create-ssouser-file', 'SSOUSER.dat'],
            $this->sqlldr('SSOUSER.par', 'SSOUSER.dat'),
            $this->sqlplus('SSOUSER.sql')
        ];
    }
}
