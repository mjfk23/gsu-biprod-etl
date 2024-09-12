<?php

declare(strict_types=1);

namespace Gsu\Biprod\Command;

use Gsu\Biprod\Entity\SSOUser;
use Gsu\Biprod\Factory\SSOUserFactory;
use mjfk23\LDAP\Connection;
use mjfk23\Log\LoggerProxyInterface;
use mjfk23\Log\LoggerProxyTrait;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

#[AsCommand('ssouser:create-file')]
final class SSOUserCreateFileCommand extends Command implements LoggerProxyInterface
{
    use LoggerProxyTrait;

    private string $base = 'OU=People,OU=Org,DC=gsuad,DC=gsu,DC=edu';
    /** @var string[] $filter */
    private array $filter = [];
    /** @var string[] $attributes */
    private array $attributes = [
        'sAMAccountName',        // campus id
        'userAccountControl',    // account status
        'memberOf',              // affiliation
        'mail',                  // email address
        'givenName',             // first name
        'sn',                    // last name
        'whenCreated',           // create date
        'whenChanged',           // update date
        'pwdLastSet',            // password changed date
    ];


    /**
     * @param Connection $ldapConnection
     * @param SSOUserFactory $ssoUserFactory
     */
    public function __construct(
        private Connection $ldapConnection,
        private SSOUserFactory $ssoUserFactory
    ) {
        parent::__construct();
        $this->filter = $this->createFilter();
    }


    /** @inheritdoc */
    protected function execute(
        InputInterface $input,
        OutputInterface $output
    ): int {
        $dataFilePath = dirname(__DIR__, 2) . '/var/sqlldr/SSOUSER.dat';

        $dataFile = fopen($dataFilePath, 'w');
        if (!is_resource($dataFile)) {
            throw new \RuntimeException(); // TODO: add message
        }

        $recordCount = 0;

        try {
            foreach ($this->fetch() as $ssoUser) {
                $status = fputcsv($dataFile, $ssoUser->createDataRow());
                if (!is_int($status) || $status < 1) {
                    throw new \RuntimeException(); // TODO: add message
                }
                $recordCount++;
            }

            $this->info("{$recordCount} users fetched");
        } finally {
            fclose($dataFile);
        }

        return self::SUCCESS;
    }


    /**
     * @return string[]
     */
    private function createFilter(): array
    {
        return [
            '(&',
            '(objectClass=User)', // Is a User object
            '(userAccountControl:1.2.840.113556.1.4.803:=512)', // Is a normal account
            '(|',
            // Has at least one 'valid' affiliation membership
            ...array_map(
                fn(string $affiliation): string => "(memberOf={$affiliation})",
                SSOUser::$AFFILIATIONS
            ),
            ')',
            '(mail=*)', // Has an email address
            '(givenName=*)', // Has a first name
            '(sn=*)', // Has a last name
            ')'
        ];
    }


    /**
     * @param int $pageSize
     * @return iterable<SsoUser>
     */
    private function fetch(int $pageSize = 1000): iterable
    {
        yield from $this->ldapConnection->forEach(
            $this->base,
            $this->filter,
            $this->attributes,
            fn($entry) => $this->ssoUserFactory->create(
                $this->ldapConnection->fetch(
                    $entry,
                    $this->attributes
                )
            ),
            $pageSize
        );
    }
}
